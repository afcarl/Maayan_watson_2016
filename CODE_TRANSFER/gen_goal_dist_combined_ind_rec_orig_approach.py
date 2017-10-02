import sys
import os
import glob
import re
import math
import datetime
import collections
import random

from parse_pddl_utils import *
from gen_obs_ind import *

big_dist_dict_P = {}
big_dist_dict_Q_HIGH = {}
big_dist_dict_Q_LOW = {}
big_dist_dict_T = {}


def create_template(path):
    k_problem = open("k-problem.pddl", 'r')
    template_file = open("k_problem_template.pddl".format(path), 'w+')
    in_goal_section = False
    for line in k_problem:
        if in_goal_section:
            if line.find('(') and line.find(')'):
                continue
            else:
                # print("STOPPED HERE")
                # print(line)
                template_file.write("<HYPOTHESIS>")
                template_file.write('\n')
                template_file.write(')')
                template_file.write('\n')
                in_goal_section = False
        if line.find(':goal') != -1:
            in_goal_section = True
        template_file.write(line)
    template_file.close()


def insert_hyp_to_template(template_file, hyp, path):
    # os.system("cp " + path + "/template.pddl " + path + "/curr_hyp.pddl")
    os.system("cp k_problem_template.pddl " + path + "/curr_hyp.pddl")
    currHyp = open('{0}/curr_hyp.pddl'.format(path), 'w')
    fluents = hyp.split(',')
    # with open(path + "/" + template_file, 'r') as template:
    with open("k_problem_template.pddl", 'r') as template:
        for line in template:
            if line.find('<HYPOTHESIS>') == -1:
                currHyp.write(line)
            else:
                currHyp.write(hyp.replace(',', " "))
    currHyp.write('\n')
    currHyp.close()


def get_curr_hyp_costs_set(domain_file, problem_file, path, num_of_plans):
    os.system("rm -r plan*")

    timeout = 120

    cmd = "./lpg-td -o {0} -f {2}/{1} -n 5 -cputime {3} -out plan_lpg_td > out_lpg_td".format(domain_file, problem_file,
                                                                                              path,
                                                                                              timeout)  # > out_lpg_td.txt -cputime 600
    os.system(cmd)

    costs = []

    plan_template = "plan_lpg_td_SOLUTION_NUM.SOL"

    plans = {}

    for i in range(1, 6):
        plan_file_name = plan_template.replace("SOLUTION_NUM", str(i))

        try:
            f = open(plan_file_name, 'r')
            for line in f:
                if line.find("MetricValue") != -1 or line.find("MakeSpan") != -1:
                    temp_make_span = float(re.sub("[^0-9.]", "", line))
                    costs.append(temp_make_span)
        except:
            break

    costs.sort()
    costs.reverse()

    os.system("rm plan_lpg_td*")
    return costs[(-1 * num_of_plans):]


def get_best_plan_cost(domain_file, problem_file, path, planner='lpg'):
    os.system("rm -r plan*")

    if planner == 'lpg':
        cmd = "./lpg-td -o {0} -f {2}/{1} -nobestfirst -n 32 -cputime 20 -out plan_lpg_td > out_lpg_td.txt".format(
            domain_file, problem_file, path)  # > out_lpg_td.txt -cputime 600

    os.system(cmd)

    make_span = sys.maxint
    best_plan_file_name = "idsjiapojdoasj"
    if planner == 'lpg':
        print("Using LPG-TD")
        plan_template = "plan_lpg_td_SOLUTION_NUM.SOL"

        plans = {}
        num_of_plans = 0

        for i in range(1, 31):
            plan_file_name = plan_template.replace("SOLUTION_NUM", str(i))

            try:
                f = open(plan_file_name, 'r')
                for line in f:
                    if line.find("MetricValue") != -1 or line.find("MakeSpan") != -1:
                        temp_make_span = float(re.sub("[^0-9.]", "", line))
                        if temp_make_span < make_span:
                            best_plan_file_name = plan_file_name
                            make_span = temp_make_span
            except:
                break

    try:
        f = open(best_plan_file_name, 'r')
        for line in f:
            print(line)
    except:
        print("cannot print plan")

    os.system("rm plan_lpg_td*")
    return make_span


def normalize(probs):
    if sum(probs) == 0:
        return probs
    prob_factor = 1 / sum(probs)
    return [prob_factor * p for p in probs]


def compute_goals_posterior_probability_hybrid(plans_costs, sum_of_plan_costs, max_of_plan_costs):
    not_normed_plan_probs_sum = []
    not_normed_plan_probs_max = []
    goals_prob_dist_sum = []
    goals_prob_dist_max = []
    prob_sum = 0
    prob_max = 0

    for plan_cost in plans_costs:
        if sum_of_plan_costs == plan_cost:
            not_normed_plan_probs_sum.append(1.0)
            not_normed_plan_probs_max.append(1.0)
        else:
            not_normed_plan_probs_sum.append((1 - (plan_cost / (sum_of_plan_costs - plan_cost))))
            not_normed_plan_probs_max.append(1 - (plan_cost / (max_of_plan_costs)))

    return not_normed_plan_probs_sum, not_normed_plan_probs_max


def compute_goals_posterior_probability(path_to_dir, dict_of_plan_costs, set_of_plans_goals, ind_hyps_path, ind=0):
    sum_of_plan_costs = sum(dict_of_plan_costs.values())
    max_of_plan_costs = max(dict_of_plan_costs.values())
    not_normed_plan_probs_sum = []
    not_normed_plan_probs_max = []
    goals_prob_dist_sum = []
    goals_prob_dist_max = []

    for plan in dict_of_plan_costs:
        curr_plan_cost = dict_of_plan_costs[plan]
        not_normed_plan_probs_sum.append(1 - (curr_plan_cost / (sum_of_plan_costs - curr_plan_cost)))
        not_normed_plan_probs_max.append(1 - (curr_plan_cost / (max_of_plan_costs)))
    # Display the plan with the highest probability. Either max of not_normed_plan_probs, or after normalization

    normed_plan_probs_sum = normalize(not_normed_plan_probs_sum)
    normed_plan_probs_max = normalize(not_normed_plan_probs_max)

    hyps = []

    if ind:
        inHypsFile = file(path_to_dir + "/hyps_ind.dat", "r")
    else:
        inHypsFile = file(path_to_dir + "/hyps.dat", "r")
    hypothesis = inHypsFile.readlines()
    cleanhypothesis = [l.split(",") for l in hypothesis if l.strip()]
    hashed_hyps = []

    for hyp in cleanhypothesis:
        hyp_hash = 0
        actionname = " ".join(str(x) for x in hyp).replace(" ", "_")
        hyp_hash = hash(actionname)
        hashed_hyps.append(hyp_hash)

        prob = 0
        prob_max = 0
        for idx in range(len(set_of_plans_goals)):
            if str(hyp_hash).find(set_of_plans_goals[idx]) != -1:
                prob += normed_plan_probs_sum[idx]
                prob_max += normed_plan_probs_max[idx]

        goals_prob_dist_sum.append(prob)
        goals_prob_dist_max.append(prob_max)
    return goals_prob_dist_sum, goals_prob_dist_max


def compute_goal_posterior_probability_delta(cost_no_obs, cost_obs):
    print(cost_no_obs)
    print(cost_obs)
    if cost_no_obs == -1 or cost_no_obs == sys.maxint or cost_obs == -1 or cost_obs == sys.maxint:
        return 0
    prob = math.exp(-1 * (abs(math.log10(cost_no_obs) - math.log10(cost_obs)))) / (
    1 + math.exp(-1 * (abs(math.log10(cost_no_obs) - math.log10(cost_obs)))))

    return prob


def find_individual_plans(best_plan, set_of_agents, domain_actions, pp, plan_dict):
    ops_seq, agents, modified_pos_dict = sample_ops_from_plan_group_of_agents(set_of_agents, best_plan, 100, pp.agents,
                                                                              plan_dict)
    obs_seq, noisy_obs = get_operators_effects(domain_actions, ops_seq, 0, pp, len(best_plan), modified_pos_dict)

    return obs_seq, agents


def find_best_joint_plan(pp, path_to_dir, subset, domain_name, problem_file):
    timeout = 450

    # os.system("./lpg -o k-domain.pddl_converted.pddl_added_goal_actions.pddl -f {3}/template.pddl_converted.pddl_added_goal_actions.pddl -d_coefficient {0} -k_coefficient {1} -cputime {2} -out set_of_plans_lpg -v off > out_lpg.txt".format(str(d_cofficient), str(plan_set_size), timeout, path_to_dir)) # > out_lpg.txt
    os.system(
        "./lpg-td -o k-domain.pddl_converted.pddl_added_goal_actions.pddl -f {0}/template.pddl_converted.pddl_added_goal_actions.pddl -nobestfirst -n 33 -cputime {1} -out plan_lpg_td > out_lpg_td.txt".format(
            path_to_dir, timeout))  # > out_lpg_td.txt -cputime 600

    make_span = sys.maxint

    print("Using LPG-TD")
    plan_template = "plan_lpg_td_SOLUTION_NUM.SOL"

    plans = {}
    num_of_plans = 0

    for i in range(1, 32):
        plan_file_name = plan_template.replace("SOLUTION_NUM", str(i))

        try:
            f = open(plan_file_name, 'r')
            for line in f:
                if line.find("MetricValue") != -1 or line.find("MakeSpan") != -1:
                    temp_make_span = float(re.sub("[^0-9.]", "", line))
                    if temp_make_span < make_span:
                        best_plan_file = plan_file_name
                        make_span = temp_make_span
        except:
            break

    plan = []
    domain_actions = {}
    # pp = PlanningProblem("{0}/domain.pddl",
    #                     "{1}/template.pddl_converted.pddl_added_goal_actions.pddl".format(path_to_dir))
    for action in pp.actions:
        domain_actions[action.name] = action

    with open(best_plan_file, 'r') as plan_file:
        for line in plan_file:
            plan.append(line)

    MakeSpan = 0
    plan = plan[12:]
    plan_dict = {}
    # print(domain_actions)
    # while(1):
    #    continue
    for step in plan:
        # print(step)
        if step == '\n':
            break

        op = step[step.find('('): (step.find('[') - 1)]
        op_name = op.split()[0][1:].lower()
        try:
            curr_action = domain_actions[op_name]
        except:
            print(step)
            continue
        if float(step[0:step.find(':')]) + float(curr_action.duration) in list(plan_dict):
            a = float(step[0:step.find(':')])
            op = step[step.find('('): (step.find('[') - 1)]
            op_name = op.split()[0][1:].lower()
            if op_name[-1] == ')':
                op_name = op_name[:-1]
            try:
                curr_action = domain_actions[op_name]
            except:
                print(op_name)
                continue
            a += float(curr_action.duration)

            while a in list(plan_dict):
                a += 0.0001
            plan_dict[a] = step
        else:
            a = float(step[0:step.find(':')])
            op = step[step.find('('): (step.find('[') - 1)]
            op_name = op.split()[0][1:].lower()
            try:
                curr_action = domain_actions[op_name]
            except:
                print(op_name)
                continue
            plan_dict[float(step[0:step.find(':')]) + float(
                curr_action.duration)] = step  # limit to 2 places after decimal point?

    sorted_steps = collections.OrderedDict(sorted(plan_dict.items()))

    clean_plan_dict = {}
    pos = 0
    for key in sorted_steps:
        clean_plan_dict[pos] = key
        pos += 1

    print(clean_plan_dict)
    plan_steps = [sorted_steps[step][sorted_steps[step].find('('): (sorted_steps[step].find('[') - 1)] for step in
                  sorted_steps]

    for step in plan_steps:
        print(step)

    # print(pp.print_problem())
    # print(pp.print_domain())

    # print(list(pp.agents)[0].upper())
    # random.choice  CHANGE TO THIS
    # list(pp.agents)[0].upper()
    agents_to_follow = []  # "PLANE3", "PLANE2"]
    for agent in pp.agents:
        if subset.find(agent) != -1:
            agents_to_follow.append(agent.upper())

    if domain_name == 'depo':
        for line in problem_file:
            for ag in agents_to_follow:
                if ag.find('DRIVER') != -1:
                    if (line.find(ag.lower()) != -1) and (line.find('driving') != -1) and (line.find('truck') != -1):
                        truck = line[line.find('truck'):-2]
                        agents_to_follow.append(truck)

    individual_obs, agents_to_keep = find_individual_plans(plan_steps, agents_to_follow, domain_actions, pp,
                                                           clean_plan_dict)

    # obs_file = open("obs_{0}.txt".format(str(set_of_agents)), 'w')
    obs_file = open("{0}/obs_ind.txt".format(path_to_dir), 'w')
    print("WE ARE FOLLOWING: {0}".format(agents_to_follow))
    for ob in individual_obs:
        print(ob)
        obs_file.write(ob + "\n")


        # obs_file = open("obs_{0}.txt".format(str(set_of_agents)), 'w')
        # for ob in individual_obs:
        #    obs_file.write(ob + "\n")

        # for plan in individual_plans:
        # recognize_individual_goal(individual_plan)
    #    compute_dist(.......)

    os.system("rm plan_lpg_td*")
    print("AGENTS_TO_KEEP")
    print(agents_to_keep)
    agents_to_keep_lower = [agent.lower() for agent in agents_to_keep]
    agents_to_delete = []
    for agent in pp.agents:
        if agent not in agents_to_keep_lower:
            agents_to_delete.append(agent)
    print("AGENTS_TO_DELETE")
    print(agents_to_delete)
    return agents_to_delete


def create_prob_dist_file(normed_goal_probs, full_path, path, subset, mode='no_mode'):
    hyps_file = open(path + "/hyps_ind_{0}.dat".format(subset), "r")

    hyps_dist = open("{0}/hyps_dist_{1}.txt".format(full_path, mode), 'w')

    dists_file = open('goal_dists_by_prob.txt', 'a')
    dists_file.write('===============\n{0}   looking at: {1}\n================\n'.format(full_path, subset))

    dists_file.write('{0}\n'.format(mode))

    for i, hyp in enumerate(hyps_file):
        if i > 3:
            break
        if i == 0:
            hyps_dist.write("******* TRUE GOAL *******\n")  # change, will not always be the first hyp
            dists_file.write("******* TRUE GOAL *******\n")  # change, will not always be the first hyp
        hyps_dist.write(hyp)
        hyps_dist.write("\t" + str(normed_goal_probs[i]) + "\n")
        dists_file.write(hyp)
        dists_file.write("\t" + str(normed_goal_probs[i]) + "\n")

    hyps_dist.close()
    dists_file.close()


def compute_dist_hybrid(path_to_dir, domain_name, problem, problem_path, num_of_plans):
    domain_file = "k-domain.pddl_converted.pddl"
    template_file = "template.pddl"
    curr_hyp_conv = "curr_hyp.pddl_converted.pddl"

    not_normed_goal_probs = []
    not_normed_goal_probs_max = []

    hyps_plans_dict = {}
    sum_of_plans_costs = 0
    max_of_plans_costs = 0
    plans_costs = []
    indexes = []
    index = 0

    # Compile away MA - Call MA script
    pp, max_duration = compile_away_ma(path_to_dir + "/domain.pddl", path_to_dir + "/" + problem + ".pddl", "0",
                                       'penalty_on')

    os.system("cp {0}/hyps.dat ".format(problem_path) + path_to_dir + "/hyps.dat")

    with open('{0}/hyps.dat'.format(problem_path)) as hypotheses:
        create_template(path_to_dir)
        for i, hyp in enumerate(hypotheses):
            insert_hyp_to_template(template_file, hyp, path_to_dir)
            print(hyp)
            cmd = "python compile_away_observations_time_penalty.py k-domain.pddl " + path_to_dir + "/curr_hyp.pddl " + path_to_dir + "/obs.txt {0} diverse".format(
                str(max_duration * 500))
            os.system(cmd)

            costs_set = get_curr_hyp_costs_set(domain_file, curr_hyp_conv, path_to_dir, num_of_plans)
            print(costs_set)

            if len(costs_set) != 0:
                indexes.append(len(costs_set))
                plans_costs += costs_set
                hyps_plans_dict[hash(hyp)] = costs_set
                sum_of_plans_costs += sum(costs_set)
                if max(costs_set) > max_of_plans_costs:
                    max_of_plans_costs = max(costs_set) + 1
            else:
                indexes.append(-1)
                hyps_plans_dict[hash(hyp)] = -1

    print(indexes)
    if sum(indexes) == (-1 * len(indexes)):
        return -1

    not_normed_plans_probs_sum, not_normed_plans_probs_max = compute_goals_posterior_probability_hybrid(plans_costs,
                                                                                                        sum_of_plans_costs,
                                                                                                        max_of_plans_costs)  # TODO - change this function
    normed_plans_probs_sum = normalize(not_normed_plans_probs_sum)
    normed_plans_probs_max = normalize(not_normed_plans_probs_max)

    for idx in indexes:
        if idx == -1:
            not_normed_goal_probs.append(0)
            not_normed_goal_probs_max.append(0)
        else:
            not_normed_goal_probs.append(sum(normed_plans_probs_sum[index: index + idx]))
            not_normed_goal_probs_max.append(sum(normed_plans_probs_max[index: index + idx]))
            index += idx

    normed_goal_probs = normalize(not_normed_goal_probs)
    normed_goal_probs_max = normalize(not_normed_goal_probs_max)
    print("SUM")
    print(normed_goal_probs)
    print("MAX")
    print(normed_goal_probs_max)
    if sum(normed_goal_probs) == 0:
        return -1
    create_prob_dist_file(normed_goal_probs, path_to_dir, problem_path, 'sum')
    create_prob_dist_file(normed_goal_probs_max, path_to_dir, problem_path, 'max')
    return normed_goal_probs_max


def compute_dist_delta(path_to_dir, domain_name, problem, problem_path, best_plan_costs, subset, agents_to_delete=[]):
    domain_file = "k-domain.pddl_converted.pddl"
    template_file = "template.pddl"
    curr_hyp_conv = "curr_hyp.pddl_converted.pddl"

    not_normed_goal_probs = []

    # Compile away MA - Call MA script
    pp, max_duration = compile_away_ma(path_to_dir + "/domain.pddl", path_to_dir + "/" + problem + ".pddl", "0",
                                       'penalty_off', agents_to_delete)

    os.system(
        "cp {0}/hyps_ind_{1}.dat ".format(problem_path, subset) + path_to_dir + "/hyps_ind_{0}.dat".format(subset))

    with open('{0}/hyps_ind_{1}.dat'.format(problem_path, subset)) as hypotheses:
        create_template(path_to_dir)
        for i, hyp in enumerate(hypotheses):
            if i > 3:
                break
            insert_hyp_to_template(template_file, hyp, path_to_dir)
            cmd = "python compile_away_observations_time_penalty.py k-domain.pddl " + path_to_dir + "/curr_hyp.pddl " + path_to_dir + "/obs.txt {0}".format(
                str(max_duration * 500))
            os.system(cmd)

            best_plan_cost = get_best_plan_cost(domain_file, curr_hyp_conv, path_to_dir)
            print(hyp)
            print(best_plan_cost)
            if best_plan_costs[i] == sys.maxint or best_plan_costs[i] == -1:
                # No plan found by planner
                prob = 0
            else:
                prob = compute_goal_posterior_probability_delta(best_plan_costs[i], best_plan_cost)

            not_normed_goal_probs.append(prob)

    if sum(not_normed_goal_probs) == 0:
        return -1
    normed_goal_probs = normalize(not_normed_goal_probs)
    print(normed_goal_probs)
    # while(1):
    #    a=0
    create_prob_dist_file(normed_goal_probs, path_to_dir, problem_path, subset)
    return normed_goal_probs


def get_dict_of_plan_costs(path_to_dir, d_cofficient=0.5, plan_set_size=50):
    timeout = 300

    os.system(
        "./lpg -o k-domain.pddl_converted.pddl_added_goal_actions.pddl -f {3}/template.pddl_converted.pddl_added_goal_actions.pddl -d_coefficient {0} -k_coefficient {1} -cputime {2} -out set_of_plans_lpg -v off > out_lpg.txt".format(
            str(d_cofficient), str(plan_set_size), timeout, path_to_dir))  # > out_lpg.txt

    plan_count = len(glob.glob1('./', "set_of_plans_lpg*"))

    if plan_count == 0:
        return -1, -1

    cost_dict = {}
    plans_goals = []
    plan_template = "set_of_plans_lpg_SOLUTION_NUM.SOL"
    for i in range(0, int(plan_set_size)):
        plan_file_name = plan_template.replace("SOLUTION_NUM", str(i))
        with open(plan_file_name, 'r') as plan_file:
            for line in plan_file:
                if line.find("MetricValue") != -1 or line.find("MakeSpan") != -1:
                    make_span = float(line[line.find(":") + 2: -1].rstrip("\n"))
                    print(make_span)
                    cost_dict[plan_file_name] = make_span
                if (line.lower().find("(goal") != -1):
                    goal = line[line.lower().find("(goal") + 6: line.lower().find(")")]
                    plans_goals.append(goal)

    return cost_dict, plans_goals


def compute_dist(path_to_dir, domain_name, problem_name, problem_path, subset):
    domain_file = "k-domain.pddl_converted.pddl"
    template_file = "template.pddl"
    curr_hyp = "curr_hyp.pddl"
    os.system("rm k-*")
    os.system("rm template.pddl_*")
    os.system("rm set_of_plans*")
    problem_file = open(path_to_dir + "/" + problem_name + ".pddl", 'r')
    # Compile away MA - Call MA script
    pp, max_duration = compile_away_ma(path_to_dir + "/domain.pddl", path_to_dir + "/" + problem_name + ".pddl", "0",
                                       'penalty_on')
    dist_dict = {}
    not_normed_goal_probs = []
    # while(1):
    #    continue
    cmd = "python compile_away_observations_time_penalty.py k-domain.pddl " + path_to_dir + "/template.pddl " + path_to_dir + "/obs.txt {0} diverse".format(
        str(max_duration * 500))
    os.system(cmd)
    os.system(
        "python remove_hyp_from_prob.py k-domain.pddl_converted.pddl {0}/template.pddl_converted.pddl {1}/hyps.dat".format(
            path_to_dir, problem_path))
    os.system(cmd)
    agents_to_delete = find_best_joint_plan(pp, path_to_dir, subset, domain_name, problem_file)  # also return plan goal

    ret_val = delta('lpg', domain_name, problem_name, path_to_dir, problem_path, subset, agents_to_delete)

    return ret_val

    cmd = "python compile_away_observations_time_penalty.py k-domain.pddl " + path_to_dir + "/template.pddl " + path_to_dir + "/obs_ind.txt {0} diverse".format(
        str(max_duration * 500))
    os.system(cmd)
    os.system(
        "python addGoalActions.py k-domain.pddl_converted.pddl {0}/template.pddl_converted.pddl {0}/hyps_ind.dat".format(
            path_to_dir))
    os.system(cmd)

    dict_of_plan_costs, list_of_plans_goals = get_dict_of_plan_costs(path_to_dir, d,
                                                                     num_of_plans)  # also return plan goal
    if dict_of_plan_costs == -1:
        return -1
        # Get PROB(G) uniformally distributed - so 1 / num_of_hyps
    not_normed_goal_probs, not_normed_goal_probs_max = compute_goals_posterior_probability(problem_path,
                                                                                           dict_of_plan_costs,
                                                                                           list_of_plans_goals, 1)
    normed_goal_probs = normalize(not_normed_goal_probs)
    normed_goal_probs_max = normalize(not_normed_goal_probs_max)

    print(normed_goal_probs)
    print(normed_goal_probs_max)
    while (1):
        a = 0

    if sum(normed_goal_probs) == 0:
        return -1
    create_prob_dist_file(normed_goal_probs, path_to_dir, problem_path, 'sum')
    create_prob_dist_file(normed_goal_probs_max, path_to_dir, problem_path, 'max')
    print(normed_goal_probs)

    return normed_goal_probs


def append_res_file(res_file_name, percentages, noise, timeouts, domain_name):
    res_file = open(res_file_name, 'a')

    for pct in percentages:
        for val in noise:
            try:
                dict_key = domain_name + '_{0}_{1}'.format(str(pct), str(val))

                res_file.write(dict_key + "_T\t")
                res_file.write(str(sum(big_dist_dict_T[dict_key]) / len(big_dist_dict_T[dict_key])))
                res_file.write('\n')

                a = int(float(sum(big_dist_dict_Q_HIGH[dict_key])) / float(len(big_dist_dict_Q_HIGH[dict_key])) * 100)
                res_file.write(dict_key + "_Q_HIGH\t")
                res_file.write(str(a))
                res_file.write('\n')

                a = int(float(sum(big_dist_dict_Q_LOW[dict_key])) / float(len(big_dist_dict_Q_LOW[dict_key])) * 100)
                res_file.write(dict_key + "_Q_LOW\t")
                res_file.write(str(a))
                res_file.write('\n')

                res_file.write(dict_key + "_P\t")
                res_file.write(str(sum(big_dist_dict_P[dict_key]) / len(big_dist_dict_P[dict_key])))
                res_file.write('\n')


            except:
                continue

    res_file.write("======= TIMEOUTS =======\n")
    for timeout in timeouts:
        res_file.write(timeout)
        res_file.write('\n')
    res_file.close()


def ind_goal_rec(domain = 0):
    percentages = [100, 70, 40, 10]
    noise = [0]  # , '14PL', '14OL']
    domains = []
    timeouts = []
    if domain == 0:
        list_of_problems = open('list_of_problems.txt', 'r')
    else:
        list_of_problems = open('list_of_problems_{0}.txt'.format(domain), 'r')


    dists_file = open('goal_dists_by_prob.txt', 'w')
    dists_file.close()

    working_file = open('gen_goal_dist_working.txt', 'w')
    working_file.close()

    timing_file = open('timing.txt', 'w')
    timing_file.close()

    res_file = open('results_IND_ORIG_APPROACH.txt', 'w')
    res_file.close()

    for line in list_of_problems:
        if line[0] == '#':
            continue
        line_s = line.split(',')
        domain_name = line_s[0][7:].strip()
        domains.append(domain_name)
        print(domain_name)
        for pct in percentages:
            for val in noise:
                dict_key = domain_name + '_{0}_{1}'.format(str(pct), str(val))
                big_dist_dict_Q_HIGH[dict_key] = []
                big_dist_dict_Q_LOW[dict_key] = []
                big_dist_dict_P[dict_key] = []
                big_dist_dict_T[dict_key] = []

        for prob in line_s[1:]:
            problem = prob.strip()
            problem_path = domain_name + "/" + problem
            agent_subsets_file = open('{0}/agent_subset_list.txt'.format(problem_path), 'r')
            temp_subsets = []
            for subset in agent_subsets_file:
                temp_subsets.append(subset)
            if len(temp_subsets) < 3:
                agent_subsets = temp_subsets
            else:
                agent_subsets = random.sample(temp_subsets, 3)
            best_plan_costs_dict = {}
            with open('{0}/plans_list.txt'.format(problem_path), 'r') as plans_list_file:
                for plan in plans_list_file:
                    for val in noise:
                        for pct in percentages:
                            for subset in agent_subsets:
                                path = problem_path + "/" + plan.rstrip('\n') + "/" + str(pct) + "/" + str(val)
                                subset_stripped = subset.strip()
                                print("***********************************************************")
                                print(path + " " + subset_stripped)
                                print("***********************************************************")

                                working_file = open('gen_goal_dist_working.txt', 'a')
                                working_file.write(
                                    '{0}_{1}_{2}_{3}_{4}_{5}_Working\n'.format(domain_name, problem, plan, pct, val,
                                                                               subset_stripped))
                                working_file.close()

                                start = datetime.datetime.now()
                                ret_val = delta('lpg', path, domain_name, problem, problem_path, subset_stripped, best_plan_costs_dict)
                                #                                print("DONE WITH EVERYTHING")

                                end = datetime.datetime.now()

                                dict_key = domain_name + '_{0}_{1}'.format(str(pct), str(val))
                                big_dist_dict_T[dict_key].append((end - start).seconds)

                                timing_file = open('timing.txt', 'a')
                                timing_file.write(
                                    '{0}_{1}_{2}_{3}_{4}_{5}_Working\n'.format(domain_name, problem, plan, pct, val,
                                                                               subset_stripped))
                                timing_file.write('{0} (s) \n'.format(str((end - start).seconds)))
                                timing_file.close()
                                # print(dict_key)
                                # print(big_dist_dict_T[dict_key])

                                if ret_val == -1:
                                    print("**** TIMEOUT ****")
                                    timeouts.append(
                                        domain_name + " " + problem + '_{0}_{1}_{2}'.format(str(pct), str(val),
                                                                                            subset_stripped))
                                    continue

                                # dict_key = domain_name + '_{0}_{1}'.format(str(pct), str(val))
                                big_dist_dict_P[dict_key].append(ret_val[0])
                                if ret_val[0] > 0.03:
                                    if ret_val.index(max(ret_val)) == 0:
                                        big_dist_dict_Q_HIGH[dict_key].append(1)
                                        big_dist_dict_Q_LOW[dict_key].append(0)
                                    else:
                                        big_dist_dict_Q_HIGH[dict_key].append(0)
                                        big_dist_dict_Q_LOW[dict_key].append(1)
                                else:
                                    big_dist_dict_Q_HIGH[dict_key].append(0)
                                    big_dist_dict_Q_LOW[dict_key].append(0)

                                working_file = open('gen_goal_dist_working.txt', 'a')
                                working_file.write(
                                    '{0}_{1}_{2}_{3}_{4}_{5}_DONE\n'.format(domain_name, problem, plan, pct, val,
                                                                            subset_stripped))
                                working_file.close()

        append_res_file('results_IND_ORIG_APPROACH.txt', percentages, noise, timeouts, domain_name)


def delta(planner, path, domain_name, problem, problem_path, subset, best_plan_costs_dict):
    best_plan_costs = []
    compile_away_ma(problem_path + "/domain.pddl", problem_path + "/" + problem + ".pddl", "0", 'penalty_off',)

    with open('{0}/hyps_ind_{1}.dat'.format(problem_path, subset), 'r') as hypotheses:
        create_template(problem_path)
        for i, hyp in enumerate(hypotheses):
            if i > 3:
                break
            print(hyp)
            print(hash(hyp.strip()))
            if hash(hyp.strip()) in best_plan_costs_dict:
                best_plan_costs.append(best_plan_costs_dict[hash(hyp.strip())])
                print(problem_path)
                print(best_plan_costs_dict[hash(hyp.strip())])
                continue
            insert_hyp_to_template("template.pddl".format(problem_path), hyp, problem_path)
            best_plan_cost = get_best_plan_cost('k-domain.pddl', 'curr_hyp.pddl', problem_path, planner)

            print(problem_path)
            print(best_plan_cost)
            if best_plan_cost == sys.maxint:
                best_plan_cost = -1
            best_plan_costs.append(best_plan_cost)
            best_plan_costs_dict[hash(hyp.strip())] = best_plan_cost
            print(best_plan_costs_dict)


    # with open('{0}/hyps_ind_{1}.dat'.format(problem_path, subset), 'r') as hypotheses:
    #     create_template(problem_path)
    #     for i, hyp in enumerate(hypotheses):
    #         if i > 3:
    #             break
    #         print(hyp)
    #         insert_hyp_to_template("template.pddl".format(problem_path), hyp, problem_path)
    #         best_plan_cost = get_best_plan_cost('k-domain.pddl', 'curr_hyp.pddl', problem_path, planner)
    #
    #         print(problem_path)
    #         print(best_plan_cost)
    #         if best_plan_cost == sys.maxint:
    #             best_plan_cost = -1
    #         best_plan_costs.append(best_plan_cost)

    ret_val = compute_dist_delta(path, domain_name, problem, problem_path, best_plan_costs, subset)
    return ret_val

    # for pct in percentages:
    #     for val in noise:
    #         dict_key = domain_name + '_{0}_{1}'.format(str(pct), str(val))
    #         big_dist_dict_Q_HIGH[dict_key] = []
    #         big_dist_dict_Q_LOW[dict_key] = []
    #         big_dist_dict_P[dict_key] = []
    #         big_dist_dict_T[dict_key] = []

    # with open('{0}/plans_list.txt'.format(problem_path), 'r') as plans_list_file:
    #     for plan in plans_list_file:
    #         for pct in percentages:
    #             for val in noise:
    #                 path = problem_path + "/" + plan.rstrip('\n') + "/" + str(pct) + "/" + str(val)
    #                 print("*******************************")
    #                 print(path)
    #                 print("*******************************")
    #
    #                 working_file = open('gen_goal_dist_working.txt', 'a')
    #                 working_file.write(
    #                     '{0}_{1}_{2}_{3}_{4}_Working'.format(domain_name, problem, plan, pct, val))
    #                 working_file.close()
    #
    #                 start = datetime.datetime.now()
    #                 ret_val = compute_dist_delta(path, domain_name, problem, problem_path, best_plan_costs, agents_to_delete)
    #                 end = datetime.datetime.now()
    #
    #                 dict_key = domain_name + '_{0}_{1}'.format(str(pct), str(val))
    #                 big_dist_dict_T[dict_key].append((end - start).seconds)
    #
    #                 timing_file = open('timing.txt', 'a')
    #                 timing_file.write(
    #                     '{0}_{1}_{2}_{3}_{4}_Working\n'.format(domain_name, problem, plan, pct, val))
    #                 timing_file.write('{0} (s) \n'.format(str((end - start).seconds)))
    #                 timing_file.close()
    #
    #                 if ret_val == -1:
    #                     print("**** TIMEOUT ****")
    #                     timeouts.append(domain_name + " " + problem + '_{0}_{1}'.format(str(pct), str(val)))
    #                     continue
    #
    #                 big_dist_dict_P[dict_key].append(ret_val[0])
    #                 if ret_val[0] > 0.03:
    #                     if ret_val.index(max(ret_val)) == 0:
    #                         big_dist_dict_Q_HIGH[dict_key].append(1)
    #                         big_dist_dict_Q_LOW[dict_key].append(0)
    #                     else:
    #                         big_dist_dict_Q_HIGH[dict_key].append(0)
    #                         big_dist_dict_Q_LOW[dict_key].append(1)
    #                 else:
    #                     big_dist_dict_Q_HIGH[dict_key].append(0)
    #                     big_dist_dict_Q_LOW[dict_key].append(0)
    #
    #                 working_file = open('gen_goal_dist_working\n.txt', 'a')
    #                 working_file.write(
    #                     '{0}_{1}_{2}_{3}_{4}_DONE\n'.format(domain_name, problem, plan, pct, val))
    #                 working_file.close()
    #
    #     append_res_file('results_delta_hyps_ind_{0}.txt'.format(subset), percentages, noise, timeouts)

    # os.system("rm {0}/set_of_plans_lpg*".format(problem_path)
    # os.system("rm {0}/k-*").format(problem_path)
    # os.system("rm {0}/template.pddl_*").format(problem_path)


# delta('lpg')
ind_goal_rec('zeno')

# if len(sys.argv) == 1:
#     print ("Usage == python gen_goal_dist_combined {delta, diverse, hybrid}")
#     sys.exit
#
# if sys.argv[1].lower() == 'diverse':
#     diverse(0, 0)
#
# elif sys.argv[1].lower() == 'delta':
#     delta(sys.argv[2])
#
# elif sys.argv[1].lower() == 'hybrid':
#     hybrid(int(sys.argv[2]))
