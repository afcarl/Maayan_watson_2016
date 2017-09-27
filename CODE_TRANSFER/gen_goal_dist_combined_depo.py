import sys
import os
import glob
import re
import math
import datetime

from parse_pddl_utils import *

big_dist_dict_P = {}
big_dist_dict_Q_HIGH = {}
big_dist_dict_Q_LOW = {}
big_dist_dict_T = {}

def insert_hyp_to_template(template_file, hyp, path):
    os.system("cp " + path + "/template.pddl " + path + "/curr_hyp.pddl")
    currHyp = open('{0}/curr_hyp.pddl'.format(path), 'w')
    fluents = hyp.split(',')
    with open(path + "/" + template_file, 'r') as template:
        for line in template:
            if line.find('<HYPOTHESIS>') == -1:
                currHyp.write(line)
            else:
                currHyp.write(hyp.replace(',', " "))
    currHyp.write('\n')
    currHyp.close()


def get_curr_hyp_costs_set(domain_file, problem_file, path, num_of_plans, timeout = 450):
    os.system("rm -r plan*")

    print(num_of_plans)

    cmd = "./lpg-td -o {0} -f {2}/{1} -nobestfirst -n 33 -cputime {3} -out plan_lpg_td > out_lpg_td".format(domain_file, problem_file, path, timeout) #> out_lpg_td.txt -cputime 600
    os.system(cmd)

    costs = []

    plan_template = "plan_lpg_td_SOLUTION_NUM.SOL"

    plans = {}

    for i in range(1, 32):
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
    to_return = costs[(-1 * num_of_plans):]
    # if len(to_return) > 0:
    #     print(to_return)
    #     to_return[-1] = to_return[-1] / 2
    #     print(to_return)
    return to_return

def get_best_plan_cost(domain_file, problem_file, path, planner='lpg'):
    os.system("rm -r plan*")

    if planner == 'lpg':
        cmd = "./lpg-td -o {0} -f {2}/{1} -nobestfirst -n 33 -cputime 450 -out plan_lpg_td > out_lpg_td.txt".format(domain_file, problem_file, path) #> out_lpg_td.txt -cputime 600
    if planner == 'sgplan':
        cmd = "./sgplan -o {0} -f {2}/{1} -cputime 90 -out plan_sgplan".format(domain_file, problem_file, path) #> out_lpg_td.txt -cputime 600

    os.system(cmd)

    make_span = sys.maxint

    if planner == 'lpg':
        print("Using LPG-TD")
        plan_template = "plan_lpg_td_SOLUTION_NUM.SOL"

        plans = {}
        num_of_plans = 0
        best_plan_file_name = "idsjiapojdoasj"
        for i in range(1, 32):
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

    if planner == 'sgplan':
        print("Using SGPLAN")
        try:
            f = open('plan_sgplan','r')
            for line in f:
                if line.find("MetricValue") != -1:
                    make_span = float(re.sub("[^0-9.]", "", line))
        except:
            make_span = sys.maxint

    os.system("rm plan_lpg_td*")
    os.system("rm plan_sgplan")
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
            not_normed_plan_probs_sum.append( ( 1 - (plan_cost / (sum_of_plan_costs - plan_cost)) ))
            not_normed_plan_probs_max.append ( 1 - (plan_cost / (max_of_plan_costs)) )

    return not_normed_plan_probs_sum, not_normed_plan_probs_max


def compute_goals_posterior_probability(path_to_dir, dict_of_plan_costs, set_of_plans_goals):
    sum_of_plan_costs = sum(dict_of_plan_costs.values())
    max_of_plan_costs = max(dict_of_plan_costs.values())
    not_normed_plan_probs_sum = []
    not_normed_plan_probs_max = []
    goals_prob_dist_sum = []
    goals_prob_dist_max = []

    for plan in dict_of_plan_costs:
        curr_plan_cost = dict_of_plan_costs[plan]
        not_normed_plan_probs_sum.append( 1 - (curr_plan_cost / (sum_of_plan_costs - curr_plan_cost)) )
        not_normed_plan_probs_max.append( 1 - (curr_plan_cost / (max_of_plan_costs)) )
    #Display the plan with the highest probability. Either max of not_normed_plan_probs, or after normalization

    normed_plan_probs_sum = normalize(not_normed_plan_probs_sum)
    normed_plan_probs_max = normalize(not_normed_plan_probs_max)

    hyps = []

    inHypsFile  = file(path_to_dir + "/hyps.dat", "r")
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
    prob = math.exp(-1 * (abs(cost_no_obs - cost_obs)) )	 / ( 1  +  math.exp(-1 * (abs(cost_no_obs - cost_obs)) ) )

    return prob

def get_dict_of_plan_costs(path_to_dir, d_cofficient = 0.5, plan_set_size = 50):
    timeout = 300

    os.system("./lpg -o k-domain.pddl_converted.pddl_added_goal_actions.pddl -f {3}/template.pddl_converted.pddl_added_goal_actions.pddl -d_coefficient {0} -k_coefficient {1} -cputime {2} -out set_of_plans_lpg -v off > out_lpg.txt".format(str(d_cofficient), str(plan_set_size), timeout, path_to_dir)) # > out_lpg.txt


    plan_count = len(glob.glob1('./',"set_of_plans_lpg*"))

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
                    make_span = float(line[line.find(":") + 2 : -1].rstrip("\n"))
                    print(make_span)
                    cost_dict[plan_file_name] = make_span
                if (line.lower().find("(goal") != -1):
                    goal = line[line.lower().find("(goal") + 6 : line.lower().find(")")]
                    plans_goals.append(goal)

    return cost_dict, plans_goals



def create_prob_dist_file(normed_goal_probs, full_path, path, mode = 'no_mode'):
    hyps_file = open(path + "/hyps.dat", "r")

    hyps_dist = open("{0}/hyps_dist_{1}.txt".format(full_path, mode), 'w')

    dists_file = open('goal_dists_by_prob.txt','a')
    dists_file.write('===============\n{0}\n================\n'.format(full_path))

    dists_file.write('{0}\n'.format(mode))

    for i, hyp in enumerate(hyps_file):
        if i == 0:
            hyps_dist.write("******* TRUE GOAL *******\n")  # change, will not always be the first hyp
            dists_file.write("******* TRUE GOAL *******\n")  # change, will not always be the first hyp
        hyps_dist.write(hyp)
        hyps_dist.write("\t" + str(normed_goal_probs[i]) + "\n")
        dists_file.write(hyp)
        dists_file.write("\t" + str(normed_goal_probs[i]) + "\n")

    hyps_dist.close()
    dists_file.close()


def compute_dist_hybrid(path_to_dir, domain_name, problem, problem_path, num_of_plans, include_nageted = True, timeout = 450):
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
    pp, max_duration = compile_away_ma(path_to_dir + "/domain.pddl", path_to_dir + "/" + problem + ".pddl", "0", 'penalty_on')

    os.system("cp {0}/hyps.dat ".format(problem_path) + path_to_dir + "/hyps.dat")

    with open('{0}/hyps.dat'.format(problem_path)) as hypotheses:
        for i, hyp in enumerate(hypotheses):
            insert_hyp_to_template(template_file, hyp, path_to_dir)
            print(hyp)
            cmd = "python compile_away_observations_time_penalty.py k-domain.pddl " + path_to_dir + "/curr_hyp.pddl " + path_to_dir + "/obs.txt {0} diverse".format(str (max_duration * 500) )

            if not include_nageted:
                cmd = "python compile_away_observations_time_penalty.py k-domain.pddl " + path_to_dir + "/curr_hyp.pddl " + path_to_dir + "/obs_no_negated.txt {0} diverse".format(
                    str(max_duration * 500))

            os.system(cmd)

            costs_set = get_curr_hyp_costs_set(domain_file, curr_hyp_conv, path_to_dir, num_of_plans, timeout)
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
    if sum( indexes ) == (-1 * len(indexes)):
        return -1

    not_normed_plans_probs_sum, not_normed_plans_probs_max = compute_goals_posterior_probability_hybrid(plans_costs, sum_of_plans_costs, max_of_plans_costs) # TODO - change this function
    normed_plans_probs_sum = normalize(not_normed_plans_probs_sum)
    normed_plans_probs_max = normalize(not_normed_plans_probs_max)


    for idx in indexes:
        if idx == -1:
            not_normed_goal_probs.append(0)
            not_normed_goal_probs_max.append(0)
        else:
            to_add_sum = 0
            to_add_max = 0
            discount_factor = 1.0
            for i in range(idx):
                to_add_sum += normed_plans_probs_sum[index + idx - 1 - i] * discount_factor
                to_add_max += normed_plans_probs_max[index + idx - 1 - i] * discount_factor
                discount_factor /= 3

            #not_normed_goal_probs.append(sum( normed_plans_probs_sum[index : index + idx] ) )
            #not_normed_goal_probs_max.append(sum( normed_plans_probs_max[index : index + idx] ) )
            not_normed_goal_probs.append(to_add_sum)
            not_normed_goal_probs_max.append(to_add_max)
            index += idx


    normed_goal_probs = normalize(not_normed_goal_probs)
    normed_goal_probs_max = normalize(not_normed_goal_probs_max)
    print("SUM")
    print(normed_goal_probs)
    print("MAX")
    print(normed_goal_probs_max)
    if sum( normed_goal_probs ) == 0:
        return -1
    create_prob_dist_file(normed_goal_probs, path_to_dir, problem_path, 'sum')
    create_prob_dist_file(normed_goal_probs_max, path_to_dir, problem_path, 'max')
    return normed_goal_probs_max

def compute_dist_delta(path_to_dir, domain_name, problem, problem_path, best_plan_costs, include_negated = True):
    domain_file = "k-domain.pddl_converted.pddl"
    template_file = "template.pddl"
    curr_hyp_conv = "curr_hyp.pddl_converted.pddl"

    not_normed_goal_probs = []

    # Compile away MA - Call MA script
    pp, max_duration = compile_away_ma(path_to_dir + "/domain.pddl", path_to_dir + "/" + problem + ".pddl", "0", 'penalty_on')


    os.system("cp {0}/hyps.dat ".format(problem_path) + path_to_dir + "/hyps.dat")

    with open('{0}/hyps.dat'.format(problem_path)) as hypotheses:
        for i, hyp in enumerate(hypotheses):
            insert_hyp_to_template(template_file, hyp, path_to_dir)
            cmd = "python compile_away_observations_time_penalty.py k-domain.pddl " + path_to_dir + "/curr_hyp.pddl " + path_to_dir + "/obs.txt {0} diverse".format(str (max_duration * 500) )

            if not include_negated:
                cmd = "python compile_away_observations_time_penalty.py k-domain.pddl " + path_to_dir + "/curr_hyp.pddl " + path_to_dir + "/obs_no_negated.txt {0} diverse".format(
                    str(max_duration * 500))

            os.system(cmd)

            best_plan_cost = get_best_plan_cost(domain_file, curr_hyp_conv, path_to_dir)

            if best_plan_costs[i] == sys.maxint:
                # No plan found by planner
                prob = 0
            else:
                prob = compute_goal_posterior_probability_delta(best_plan_costs[i], best_plan_cost)

            not_normed_goal_probs.append(prob)

    if sum(	not_normed_goal_probs ) == 0:
        return -1
    normed_goal_probs = normalize(not_normed_goal_probs)
    print(normed_goal_probs)
    create_prob_dist_file(normed_goal_probs, path_to_dir, problem_path)
    return normed_goal_probs



def compute_dist(path_to_dir, domain_name, problem_name, problem_path, d, num_of_plans, include_nageted = True):
    domain_file = "k-domain.pddl_converted.pddl"
    template_file = "template.pddl"
    curr_hyp = "curr_hyp.pddl"
    os.system("rm k-*")
    os.system("rm template.pddl_*")
    os.system("rm set_of_plans*")
    # Compile away MA - Call MA script
    pp, max_duration = compile_away_ma(path_to_dir + "/domain.pddl", path_to_dir + "/" + problem_name + ".pddl", "0", 'penalty_on')


    dist_dict = {}
    not_normed_goal_probs = []

    cmd = "python compile_away_observations_time_penalty.py k-domain.pddl " + path_to_dir + "/template.pddl " + path_to_dir + "/obs.txt {0} diverse".format(str (max_duration * 500) )

    if not include_nageted:
        cmd = "python compile_away_observations_time_penalty.py k-domain.pddl " + path_to_dir + "/template.pddl " + path_to_dir + "/obs_no_negated.txt {0} diverse".format(
            str(max_duration * 500))

    os.system(cmd)
    os.system("python addGoalActions.py k-domain.pddl_converted.pddl {0}/template.pddl_converted.pddl {1}/hyps.dat".format(path_to_dir, problem_path))
    os.system(cmd)
    dict_of_plan_costs, list_of_plans_goals = get_dict_of_plan_costs(path_to_dir, d, num_of_plans) # also return plan goal
    if dict_of_plan_costs == -1:
        return -1
        # Get PROB(G) uniformally distributed - so 1 / num_of_hyps
    not_normed_goal_probs, not_normed_goal_probs_max = compute_goals_posterior_probability(problem_path, dict_of_plan_costs, list_of_plans_goals)
    normed_goal_probs = normalize(not_normed_goal_probs)
    normed_goal_probs_max = normalize(not_normed_goal_probs_max)

    if sum( normed_goal_probs ) == 0:
        return -1
    create_prob_dist_file(normed_goal_probs, path_to_dir, problem_path, 'sum')
    create_prob_dist_file(normed_goal_probs_max, path_to_dir, problem_path, 'max')
    print(normed_goal_probs)

    return normed_goal_probs


def append_res_file(res_file_name, percentages, noise, timeouts, domain_name, timeout_list = [], truth_vals = []):

    res_file = open(res_file_name,'a')

    for timeout in timeout_list:
        for truth_val in truth_vals:
            for pct in percentages:
                for val in noise:
                    try:
                        dict_key = domain_name + '_{0}_{1}_{2}_{3}'.format(str(pct), str(val), str(timeout), str(truth_val))

                        res_file.write(dict_key + "_T\t")
                        res_file.write(str (sum(big_dist_dict_T[dict_key]) / len(big_dist_dict_T[dict_key]) ))
                        res_file.write('\n')

                        a = int(float(sum(big_dist_dict_Q_HIGH[dict_key]))/float(len(big_dist_dict_Q_HIGH[dict_key])) * 100)
                        res_file.write(dict_key + "_Q_HIGH\t")
                        res_file.write(str  ( a   ))
                        res_file.write('\n')

                        a = int(float(sum(big_dist_dict_Q_LOW[dict_key]))/float(len(big_dist_dict_Q_LOW[dict_key])) * 100)
                        res_file.write(dict_key + "_Q_LOW\t")
                        res_file.write(str  ( a   ))
                        res_file.write('\n')

                        res_file.write(dict_key + "_P\t")
                        res_file.write(str (sum(big_dist_dict_P[dict_key]) / len(big_dist_dict_P[dict_key]) ))
                        res_file.write('\n')


                    except:
                        continue


    res_file.write("======= TIMEOUTS =======\n")
    for timeout in timeouts:
        res_file.write(timeout)
        res_file.write('\n')
    res_file.close()

def diverse(d, k, include_negated = True):
    percentages = [ 100, 70, 40, 10 ]
    noise = [0, '14PL', '14OL']
    domains = []
    timeouts = []
    list_of_problems = open('list_of_problems.txt', 'r')

    dists_file = open('goal_dists_by_prob.txt','w')
    dists_file.close()

    working_file = open('gen_goal_dist_working.txt','w')
    working_file.close()

    timing_file = open('timing.txt','w')
    timing_file.close()

    res_file = open('results_DIVERSE_d:{0}_k:{1}.txt'.format(d, k),'w')
    res_file.close()

    for line in list_of_problems:
        if line[0] == '#':
            continue
        line_s = line.split(',')
        domain_name = line_s[0][7:].strip()
        domains.append(domain_name)
        print(domain_name)
        for prob in line_s[1:]:
            problem = prob.strip()
            problem_path = domain_name + "/" + problem

            for pct in percentages:
                for val in noise:
                    dict_key = domain_name + '_{0}_{1}'.format(str(pct), str(val))
                    big_dist_dict_Q_HIGH[dict_key] = []
                    big_dist_dict_Q_LOW[dict_key] = []
                    big_dist_dict_P[dict_key] = []
                    big_dist_dict_T[dict_key] = []

            with open('{0}/plans_list.txt'.format(problem_path), 'r') as plans_list_file:
                for plan in plans_list_file:
                    for pct in percentages:
                        for val in noise:
                            path = problem_path + "/" + plan.rstrip('\n') + "/" + str(pct) + "/" + str(val)

                            print("***********************************************************")
                            print(path + "      ---   d: {0} k: {1}".format(d, k) )
                            print("***********************************************************")

                            working_file = open('gen_goal_dist_working.txt','a')
                            working_file.write('{0}_{1}_{2}_{3}_{4}_Working\n'.format(domain_name, problem, plan, pct, val))
                            working_file.close()

                            start = datetime.datetime.now()
                            ret_val = compute_dist(path, domain_name, problem, problem_path, d, k, include_negated)
                            end = datetime.datetime.now()

                            dict_key = domain_name + '_{0}_{1}'.format(str(pct), str(val))
                            big_dist_dict_T[dict_key].append((end-start).seconds)

                            timing_file = open('timing.txt','a')
                            timing_file.write('{0}_{1}_{2}_{3}_{4}_{5}_{6}_Working\n'.format(domain_name, problem, plan, pct, val, d, k))
                            timing_file.write('{0} (s) \n'.format(str((end-start).seconds)))
                            timing_file.close()
                            #print(dict_key)
                            #print(big_dist_dict_T[dict_key])

                            if ret_val == -1:
                                print("**** TIMEOUT ****")
                                timeouts.append(domain_name + " " + problem + '_{0}_{1}'.format(str(pct), str(val) ))
                                continue

                            #dict_key = domain_name + '_{0}_{1}'.format(str(pct), str(val))
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


                            working_file = open('gen_goal_dist_working.txt','a')
                            working_file.write('{0}_{1}_{2}_{3}_{4}_DONE\n'.format(domain_name, problem, plan, pct, val))
                            working_file.close()


        append_res_file('results_DIVERSE_d:{0}_k:{1}.txt'.format(d, k), percentages, noise, timeouts, domain_name)

def hybrid(num_of_plans, include_negated = True, timeout = 450):
    percentages = [ 100, 70, 40, 10 ]
    noise = [0, '14PL', '14OL']
    timeout_list = [300]
    truth_vals = [True, False]
    domains = []
    timeouts = []
    list_of_problems = open('list_of_problems_depo.txt', 'r')

    dists_file = open('goal_dists_by_prob.txt','w')
    dists_file.close()

    working_file = open('gen_goal_dist_working_DEPO.txt','w')
    working_file.close()

    timing_file = open('timing.txt','w')
    timing_file.close()

    res_file = open('results_HYBRID_DEPO.txt','w')
    res_file.close()



    for line in list_of_problems:
        if line[0] == '#':
            continue
        line_s = line.split(',')
        domain_name = line_s[0][7:].strip()
        domains.append(domain_name)
        print(domain_name)
        for timeout_temp in timeout_list:
            for truth_value in truth_vals:  # , False]:
                for pct in percentages:
                    for val in noise:
                        dict_key = domain_name + '_{0}_{1}_{2}_{3}'.format(str(pct), str(val), str(timeout_temp),
                                                                           str(truth_value))
                        big_dist_dict_Q_HIGH[dict_key] = []
                        big_dist_dict_Q_LOW[dict_key] = []
                        big_dist_dict_P[dict_key] = []
                        big_dist_dict_T[dict_key] = []
        for prob in line_s[1:]:
            problem = prob.strip()
            problem_path = domain_name + "/" + problem

            for timeout_temp in timeout_list:
                for truth_value in truth_vals:#, False]:
                    with open('{0}/plans_list.txt'.format(problem_path), 'r') as plans_list_file:
                        for plan in plans_list_file:
                            for pct in percentages:
                                for val in noise:
                                    path = problem_path + "/" + plan.rstrip('\n') + "/" + str(pct) + "/" + str(val)
                                    print("***********************************************************")
                                    print(path + " Include negated: {0}   timeout: {1}".format(truth_value, timeout_temp))
                                    print("***********************************************************")

                                    working_file = open('gen_goal_dist_working_DEPO.txt','a')
                                    working_file.write('{0}_{1}_{2}_{3}_{4}_{5}_{6}_Working\n'.format(domain_name, problem, plan, pct, val, str(timeout_temp), str(truth_value)))
                                    working_file.close()

                                    start = datetime.datetime.now()
                                    ret_val = compute_dist_hybrid(path, domain_name, problem, problem_path, num_of_plans, truth_value, timeout_temp)
                                    end = datetime.datetime.now()

                                    dict_key = domain_name + '_{0}_{1}_{2}_{3}'.format(str(pct), str(val),
                                                                                       str(timeout_temp),
                                                                                       str(truth_value))
                                    big_dist_dict_T[dict_key].append((end-start).seconds)

                                    timing_file = open('timing.txt','a')
                                    timing_file.write('{0}_{1}_{2}_{3}_{4}_{5}_{6}_Working\n'.format(domain_name, problem, plan, pct, val, str(timeout_temp), str(truth_value)))
                                    timing_file.write('{0} (s) \n'.format(str((end-start).seconds)))
                                    timing_file.close()

                                    if ret_val == -1:
                                        print("**** TIMEOUT ****")
                                        timeouts.append(domain_name + " " + problem + '_{0}_{1}'.format(str(pct), str(val) ))
                                        continue


                                    big_dist_dict_P[dict_key].append(ret_val[0])
                                    print(big_dist_dict_P)
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


                                    working_file = open('gen_goal_dist_working_DEPO.txt','a')
                                    working_file.write('{0}_{1}_{2}_{3}_{4}_{5}_{6}_DONE\n'.format(domain_name, problem, plan, pct, val, str(timeout_temp), str(truth_value)))
                                    working_file.close()


        append_res_file('results_HYBRID_DEPO.txt', percentages, noise, timeouts, domain_name, timeout_list, truth_vals)


def delta(planner, include_negated = True):
    percentages = [ 100]#, 70, 40, 10 ]
    noise = [0]#, '14PL', '14OL']
    domains = []
    best_plan_costs = []
    timeouts = []
    list_of_problems = open('list_of_problems.txt', 'r')

    dists_file = open('goal_dists_by_prob.txt','w')
    dists_file.close()

    working_file = open('gen_goal_dist_working.txt','w')
    working_file.close()

    timing_file = open('timing.txt','w')
    timing_file.close()

    res_file = open('results_delta.txt','w')
    res_file.close()

    for line in list_of_problems:
        if line[0] == '#':
            continue
        line_s = line.split(',')
        domain_name = line_s[0][7:].strip()
        domains.append(domain_name)
        print(domain_name)
        for prob in line_s[1:]:
            problem = prob.strip()
            problem_path = domain_name + "/" + problem
            # Compile away MA - Call MA script
            compile_away_ma(problem_path + "/domain.pddl", problem_path + "/" + problem + ".pddl")
            best_plan_costs = []
            with open('{0}/hyps.dat'.format(problem_path), 'r') as hypotheses:
                for hyp in hypotheses:
                    print(hyp)
                    insert_hyp_to_template("template.pddl".format(problem_path), hyp, problem_path)
                    best_plan_cost = get_best_plan_cost('k-domain.pddl', 'curr_hyp.pddl', problem_path, planner)

                    print(problem_path)
                    print(best_plan_cost)
                    best_plan_costs.append(best_plan_cost)

            for pct in percentages:
                for val in noise:
                    dict_key = domain_name + '_{0}_{1}'.format(str(pct), str(val))
                    big_dist_dict_Q_HIGH[dict_key] = []
                    big_dist_dict_Q_LOW[dict_key] = []
                    big_dist_dict_P[dict_key] = []
                    big_dist_dict_T[dict_key] = []

            with open('{0}/plans_list.txt'.format(problem_path), 'r') as plans_list_file:
                for plan in plans_list_file:
                    for pct in percentages:
                        for val in noise:
                            path = problem_path + "/" + plan.rstrip('\n') + "/" + str(pct) + "/" + str(val)
                            print("*******************************")
                            print(path)
                            print("*******************************")

                            working_file = open('gen_goal_dist_working.txt','a')
                            working_file.write('{0}_{1}_{2}_{3}_{4}_Working'.format(domain_name, problem, plan, pct, val))
                            working_file.close()

                            start = datetime.datetime.now()
                            ret_val = compute_dist_delta(path, domain_name, problem, problem_path, best_plan_costs, include_negated)
                            end = datetime.datetime.now()

                            dict_key = domain_name + '_{0}_{1}'.format(str(pct), str(val))
                            big_dist_dict_T[dict_key].append((end-start).seconds)

                            timing_file = open('timing.txt','a')
                            timing_file.write('{0}_{1}_{2}_{3}_{4}_Working\n'.format(domain_name, problem, plan, pct, val))
                            timing_file.write('{0} (s) \n'.format(str((end-start).seconds)))
                            timing_file.close()

                            if ret_val == -1:
                                print("**** TIMEOUT ****")
                                timeouts.append(domain_name + " " + problem + '_{0}_{1}'.format(str(pct), str(val) ))
                                continue


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


                            working_file = open('gen_goal_dist_working\n.txt','a')
                            working_file.write('{0}_{1}_{2}_{3}_{4}_DONE\n'.format(domain_name, problem, plan, pct, val))
                            working_file.close()


        append_res_file('results_delta.txt', percentages, noise, timeouts, domain_name)

    #os.system("rm {0}/set_of_plans_lpg*".format(problem_path)
    #os.system("rm {0}/k-*").format(problem_path)
    #os.system("rm {0}/template.pddl_*").format(problem_path)

# if len(sys.argv) == 1:
#     print ("Usage == python gen_goal_dist_combined {delta, diverse, hybrid}")
#     sys.exit
#
# if sys.argv[1].lower() == 'diverse':
#     d = sys.argv[2]
#     num_of_plans = sys.argv[3]
#     if len(sys.argv) > 4:
#         if sys.argv[4].lower() == 'no_negated':
#             diverse(d, num_of_plans, False)
#     else:
#         print("d: {0}".format(d))
#         print("k: {0}".format(num_of_plans))
#         diverse(d, num_of_plans)
#
# elif sys.argv[1].lower() == 'delta':
#     if len(sys.argv) > 3:
#         if sys.argv[3].lower() == 'no_negated':
#             delta(sys.argv[2], False)
#     else:
#         delta(sys.argv[2])
#
#
# elif sys.argv[1].lower() == 'hybrid':
#     if len(sys.argv) > 3:
#         if sys.argv[3].lower() == 'no_negated':
#             hybrid(int(sys.argv[2]), False)
#     else:
#         hybrid(int(sys.argv[2]))


hybrid(int('3'))

# for timeout in [440, 120]:
#     for truth_value in [True, False]:
#         if truth_value:
#             print('WITH NEGATED - {0}'.format(timeout))
#         else:
#             print("NO NEGATED - {0}".format(timeout))
#         hybrid(int('3'), truth_value, timeout)