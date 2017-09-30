#!/usr/local/bin/python

import os
import sys
from parse_pddl_utils import *
import collections
import random
import math
import re


def sample_ops_from_plan_group_of_agents(set_of_agents, plan, pct, set_of_all_agents, plan_dict, not_observable=[]):
    obs_seq = []
    agents = set()
    modified_plan_dict = {}
    pos = 0
    orig_pos = 0

    for step in plan:
        for ag in set_of_agents:
            if step.find(ag.upper()) != -1:
                for agent in set_of_all_agents:
                    #print(step)
                    #print(agent)
                    if (step.find(agent.upper()) != -1):
                        agents.add(agent.upper())
                if step not in obs_seq:
                    modified_plan_dict[pos] = plan_dict[orig_pos]
                    obs_seq.append(step)
                    print(pos)
                    print(len(obs_seq))
                    pos += 1
        orig_pos += 1
                #break;


    return obs_seq, agents, modified_plan_dict


def sample_ops_from_plan(plan, pct, pos_dict, not_observable=[]):
    modified_plan_dict = {}
    #print(plan)
    observable = [i for i in range(len(plan))]
    sampled_indices = random.sample(observable, int(math.ceil((pct / 100.0) * len(observable))))
    sampled_indices.sort()
    if len(sampled_indices) == 0:
        sampled_indices = [0]

    pos = 0
    for i in sampled_indices:
        modified_plan_dict[pos] = pos_dict[i]
        pos += 1
    obs_seq = [plan[i] for i in sampled_indices]
    return obs_seq, modified_plan_dict


def get_operators_effects(domain_actions, ops_seq, noise_val, pp, plan_len, pos_dict, negated_obs = False):
    obs_seq = []
    noisy_obs = []
    obs_dict = {}
    pos = 0
    print(pos_dict)
    print(ops_seq)
    # We take all domain actions that were not observed
    not_observed_actions = [domain_actions[action] for action in domain_actions if
                            action not in [op.split()[0][1:].lower() for op in ops_seq]]

    for op in ops_seq:
        print(op)
        op_name = op.split()[0][1:].lower()
        curr_action = domain_actions[op_name]

        params = curr_action.parameters.pddl_rep()[1:].split()
        params_only = [param for param in params if param.find('?') != -1]

        params_only_types = [param.strip(')') for param in curr_action.parameters.pddl_rep()[1:].split() if
                             param.find('?') == -1 and param.find('-') == -1]
        action_effects = curr_action.effect

        for eff in action_effects:
            print(eff)
            atStart = False
            if eff.temp_attr == 'at start':
                continue
                atStart = True

            #    continue

            if eff.is_negated:
                if not negated_obs:
                    continue

            if eff.is_negated:
                observation = "(not ( " + eff.name
            else:
                observation = "( " + eff.name
            noisy_observation = "( " + eff.name
            for arg in eff.args:
                if arg == ')':
                    continue
                idx = params_only.index(arg)

                observation += " " + op.split()[idx + 1].rstrip(')')

                if not eff.is_negated:
                    # list of all other objects that do not appear in current observation's effects
                    try:
                        obj_list = [obj for obj in pp.objects[params_only_types[idx].lower()] if
                                    obj.find(op.split()[idx + 1].rstrip(')')) == -1]
                    except:
                        type = random.sample(pp.types[params_only_types[idx].lower()], 1)[0]
                        obj_list = [obj for obj in pp.objects[type] if obj.find(op.split()[idx + 1].rstrip(')')) == -1]

                    noisy_observation += " " + random.sample((obj_list), 1)[0]


            noisy_observation += " )"
            if eff.is_negated:
                observation += " ))"
            else:
                observation += " )"

            if not eff.is_negated:
                noisy_obs.append(noisy_observation)

            if atStart:
                a = pos_dict[pos] - float(curr_action.duration)
                while a in list(obs_dict):
                    a += 0.009

                obs_dict[a] = observation
            else:
                print(observation)
                print(pos_dict[pos])
                a = pos_dict[pos]
                while a in list(obs_dict):
                    a += 0.0001
                obs_dict[a] = observation
            obs_seq.append(observation)
        pos += 1

            # From list of noisy_obs randomly choose a percentage of obs, according to noise_val. Add to obs_seq
    sorted_steps = collections.OrderedDict(sorted(obs_dict.items()))
    print(sorted_steps)
    obs_seq = [sorted_steps[step] for step in sorted_steps]
    print(obs_seq)
    return obs_seq, noisy_obs

def get_best_plan(domain_actions):
    os.system("rm -r plan*")

    if 1:
        cmd = "./lpg-td -o k-domain.pddl -f k-problem.pddl -nobestfirst -n 33 -cputime 300 > out_lpg_td.txt"

    os.system(cmd)

    make_span = sys.maxint
    plan_nums = []
    print("Found best plan")

    if 1:
        print("Using LPG-TD")
        plan_template = "plan_k-problem.pddl_SOLUTION_NUM.SOL"

        plans = {}
        num_of_plans = 0

        for i in range(1, 32):
            plan_file_name = plan_template.replace("SOLUTION_NUM", str(i))
            print(plan_file_name)
            try:
                f = open(plan_file_name, 'r')
                print("good")
                for line in f:
                    if line.find("MetricValue") != -1 or line.find("MakeSpan") != -1:
                        temp_make_span = float(re.sub("[^0-9.]", "", line))
                        if temp_make_span < make_span:
                            make_span = temp_make_span
                            plan_nums = []
                            plan_nums.append(i)
            except:
                break


    print(plan_nums)
    plans = {}
    clean_plan_dict = {}
    for i in plan_nums:
        plan = []
        plan_file_name = plan_template.replace("SOLUTION_NUM", str(i))

        try:
            with open(plan_file_name, 'r') as plan_file:
                for line in plan_file:
                    plan.append(line)
            MakeSpan = 0
            plan = plan[12:]
            plan_dict = {}
            #print(len(plan))
            #print(plan)
            for step in plan:
                print(step)
                if step == '\n':
                    break
                print(float(step[0:step.find(':')]))
                print(list(plan_dict))

                op = step[step.find('('): (step.find('[') - 1)]
                op_name = op.split()[0][1:].lower()
                curr_action = domain_actions[op_name]

                if float(step[0:step.find(':')]) + float(curr_action.duration) in list(plan_dict):
                    #print(step)
                    a = float(step[0:step.find(':')])
                    op = step[step.find('('): (step.find('[') - 1)]
                    op_name = op.split()[0][1:].lower()
                    curr_action = domain_actions[op_name]
                    a += float(curr_action.duration)

                    while a in list(plan_dict):
                        a += 0.0001
                    plan_dict[a] = step
                else:
                    a = float(step[0:step.find(':')])
                    op = step[step.find('('): (step.find('[') - 1)]
                    op_name = op.split()[0][1:].lower()
                    curr_action = domain_actions[op_name]
                    plan_dict[float(step[0:step.find(':')]) + float(
                        curr_action.duration)] = step  # limit to 2 places after decimal point?
            #print(plan_dict.items())
            sorted_steps = collections.OrderedDict(sorted(plan_dict.items()))
            #print(sorted_steps)
            #print(len(sorted_steps))

            pos = 0
            for key in sorted_steps:
                clean_plan_dict[pos] = key
                pos += 1
            plan_steps = [sorted_steps[step][sorted_steps[step].find('('): (sorted_steps[step].find('[') - 1)] for step
                          in sorted_steps]
            #print(plan_steps)
            #print(len(plan_steps))
            plans[plan_file_name] = plan_steps



        except:
            print("Done with plans creation")
            break

    #os.system("rm plan_lpg_td*")

    return plans, clean_plan_dict



def get_plans(domain_actions):
    os.system("rm -r plan*")

    cmd = "./lpg-td -o k-domain.pddl -f k-problem.pddl -nobestfirst -n 20 -cputime 250 > out_lpg_td.txt"
    os.system(cmd)

    plan_template = "plan_k-problem.pddl_SOLUTION_NUM.SOL"

    plans = {}
    num_of_plans = 0

    for i in range(1, 19):
        plan_file_name = plan_template.replace("SOLUTION_NUM", str(i))

        try:
            f = open(plan_file_name, 'r')
            num_of_plans = i
        except:
            break

    plan_nums = []
    if num_of_plans < 2:
        os.system("rm -r plan*")
        cmd = "./lpg-td -o k-domain.pddl -f k-problem.pddl -n 200 -cputime 400 > out_lpg_td.txt"
        os.system(cmd)
        for i in range(1, 19):
            plan_file_name = plan_template.replace("SOULUTION_NUM", str(i))
            try:
                f = open(plan_file_name, 'r')
                num_of_plans = i
            except:
                break

    if num_of_plans < 3:
        if num_of_plans == 1:
            plan_nums = [1]
        elif num_of_plans == 2:
            plan_nums = [1, 2]
    else:
        plan_nums = random.sample(range(1, num_of_plans), 1)
        plan_nums.append(num_of_plans)

    print(plan_nums)
    for i in plan_nums:
        plan = []
        plan_file_name = plan_template.replace("SOLUTION_NUM", str(i))

        try:
            with open(plan_file_name, 'r') as plan_file:
                for line in plan_file:
                    plan.append(line)
            MakeSpan = 0
            plan = plan[12:]
            plan_dict = {}

            for step in plan:
                if step == '\n':
                    break
                if float(step[0:step.find(':')]) in list(plan_dict):
                    a = float(step[0:step.find(':')])
                    op = step[step.find('('): (step.find('[') - 1)]
                    op_name = op.split()[0][1:].lower()
                    curr_action = domain_actions[op_name]
                    a += float(curr_action.duration)

                    while a in list(plan_dict):
                        a += 0.0001
                    plan_dict[a] = step
                else:
                    a = float(step[0:step.find(':')])
                    op = step[step.find('('): (step.find('[') - 1)]
                    op_name = op.split()[0][1:].lower()
                    curr_action = domain_actions[op_name]
                    plan_dict[float(step[0:step.find(':')]) + float(
                        curr_action.duration)] = step  # limit to 2 places after decimal point?

            sorted_steps = collections.OrderedDict(sorted(plan_dict.items()))

            plan_steps = [sorted_steps[step][sorted_steps[step].find('('): (sorted_steps[step].find('[') - 1)] for step
                          in sorted_steps]
            plans[plan_file_name] = plan_steps


        except:
            print("Done with plans creation")
            break

    return plans


def get_real_hyp(problem_file):
    real_hyp = open('real_hyp.txt', 'w')
    goal_flag = False
    and_flag = False
    with open(problem_file, 'r') as p_file:
        for line in p_file:
            if goal_flag and and_flag:
                if line.find("(") == -1:
                    goal_flag = False
                    and_flag = False
                    break
                real_hyp.write(line.strip())

            if line.find(":goal") != -1 and line.find("(and") != -1:
                goal_flag = True
                and_flag = True
            if line.find(":goal") != -1 and line.find("(and") == -1:
                goal_flag = True
                and_flag = False
            if goal_flag and line.find("(and") != -1:
                and_flag = True

        p_file.close()


def create_template_file(problem_file):
    flag = False
    template_file = open('template.pddl', 'w')
    with open(problem_file, 'r') as p_file:
        for line in p_file:
            if not flag:
                template_file.write(line)
            else:
                if line == ')':
                    flag = False
            if line.find('goal') != -1:
                flag = True
                template_file.write("\t\t<HYPOTHESIS>\n")
                template_file.write(")\n")
                break
        template_file.write(")\n")
        template_file.write("(:metric minimize (total-time))\n")
        template_file.write(")\n")
    template_file.close()


def add_noise_to_obs(obs_seq, noisy_obs, val, plan_len):
    if val.find("14PL") != -1:
        val_num = int(val[0:2])
        num_of_noisy = min(int(math.ceil((val_num / 100.0) * plan_len)), len(noisy_obs))
    elif val.find("7PL") != -1:
        val_num = int(val[0:1])
        num_of_noisy = min(int(math.ceil((val_num / 100.0) * plan_len)), len(noisy_obs))
    elif val.find("OL") != -1:
        val_num = int(val[0:2])
        num_of_noisy = min(int(math.ceil((val_num / 100.0) * len(obs_seq))), len(noisy_obs))
    else:
        num_of_noisy = 0

    print("noise val: {0}".format(val))
    print (" number of noisy to add: {0}".format(num_of_noisy))
    print(len(noisy_obs))
    print(len(obs_seq))

    if len(obs_seq) == 0:
        return obs_seq

    for idx in range(num_of_noisy):
        rand_idx = random.randint(0, len(obs_seq))

        obs_seq.insert(rand_idx, noisy_obs[idx])

    print(len(obs_seq))
    return obs_seq


def create_PR_problems(domain_file, problem_file, path_to_prob_dir):
    os.system("rm -r {0}/plan_*".format(path_to_prob_dir))

    # Parse Args, expects path to domain file, problem file #
    domain_actions = {}

    compile_away_ma(domain_file, problem_file)
    create_template_file('k-problem.pddl')

    # Create real_goal.txt
    get_real_hyp(problem_file)

    pp = PlanningProblem(domain_file, problem_file, [])
    for action in pp.actions:
        domain_actions[action.name] = action

        # Get plans for sub problems #
    plans, pos_dict = get_best_plan(domain_actions)

    plans_list_file = open('{0}/plans_list.txt'.format(path_to_prob_dir), 'w')

    percentages = [100, 70, 40, 10]
    noise = [0, '14PL', '14OL', '7PL']
    for plan in plans:
        path = plan + "_PR"
        plans_list_file.write(path + "\n")
        os.system('mkdir {0}/{1}'.format(path_to_prob_dir, path))
        for pct in percentages:
            pct_path = path + "/"
            pct_path += str(pct)
            print(pct_path)
            os.system('mkdir {0}/{1}'.format(path_to_prob_dir, pct_path))

            for val in noise:
                noise_path = pct_path + "/"
                noise_path += str(val)
                print(noise_path)
                os.system('mkdir {0}/{1}'.format(path_to_prob_dir, noise_path))
                print(plans)
                # Sample %pct of operators from ground truth plan
                ops_seq, modified_pos_dict = sample_ops_from_plan(plans[plan], pct, pos_dict)

                # Get sampled operators effects
                obs_seq, noisy_obs = get_operators_effects(domain_actions, ops_seq, val, pp, len(plans[plan]), modified_pos_dict, True)
                no_negated_obs_seq, noisy_obs = get_operators_effects(domain_actions, ops_seq, val, pp, len(plans[plan]),
                                                           modified_pos_dict, False)


                if val > 0:
                    # Add random noisy observations
                    final_obs_seq_no_negated = add_noise_to_obs(no_negated_obs_seq, noisy_obs, val, len(plans[plan]))
                    final_obs_seq = add_noise_to_obs(obs_seq, noisy_obs, val, len(plans[plan]))
                else:
                    final_obs_seq_no_negated = no_negated_obs_seq
                    final_obs_seq = obs_seq

                obs_file = open("{0}/{1}/obs.txt".format(path_to_prob_dir, noise_path), 'w')
                for ob in final_obs_seq:
                    obs_file.write(ob + "\n")


                obs_file = open("{0}/{1}/obs_no_negated.txt".format(path_to_prob_dir, noise_path), 'w')
                for ob in final_obs_seq_no_negated:
                    obs_file.write(ob + "\n")

                os.system("cp real_hyp.txt {0}/{1}".format(path_to_prob_dir, noise_path))
                os.system("cp {0} {1}/{2}".format(domain_file, path_to_prob_dir, noise_path))
                os.system("cp {0} {1}/{2}".format(problem_file, path_to_prob_dir, noise_path))
                os.system("cp template.pddl {0}/{1}".format(path_to_prob_dir, noise_path))
                os.system("cp template.pddl {0}".format(path_to_prob_dir))

    plans_list_file.close()


def main():
    list_of_problems = open('list_of_problems.txt', 'r')
    f = open('START', 'w')
    f.close()
    for line in list_of_problems:
        if line[0] == '#':
            continue
        line_s = line.split(',')
        domain_name = line_s[0][7:].strip()
        for prob in line_s[1:]:
            problem = prob.strip()
            problem_path = domain_name + "/" + problem
            os.system("rm plan_*")
            create_PR_problems(problem_path + "/domain.pddl", problem_path + "/" + problem + ".pddl", problem_path)
            print("DONE_OBS_GEN_{0}".format(problem_path))
            f = open('{0}_{1}_done'.format(domain_name, problem), 'w')
            f.close()

    f = open("DONE_WITH_BENCHMARKS_CREATION.txt", 'w')
    f.close()