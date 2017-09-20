#!/usr/bin/python
import os
import re
import commands
import sys




# Take the domain, problem, and hyps.txt file, should work for both pddl and sppl
# generate one action per each goal where the precondition is the goal predicate and effect is the done predicate.
# Add the done predicate to the problem
# we will use the pddl version for LPG and sppl for top-k

#if the problem has <Hypothesis>, then juse remove it



#domain problem obs steps

inputdomain = sys.argv[1]
inputproblem = sys.argv[2]
inputhyp = sys.argv[3]



inProblemFile  = file(inputproblem, "r")
inDomainFile  = file(inputdomain, "r")
inHypsFile  = file(inputhyp, "r")

if (inputdomain.find("sppl") != -1 ):
    outDomain = file(inputdomain+"_added_goal_actions.sppl", "w")
    outProblem  = file(inputproblem+"_added_goal_actions.sppl", "w")
else :
    outDomain = file(inputdomain+"_added_goal_actions.pddl", "w")
    outProblem  = file(inputproblem+"_added_goal_actions.pddl", "w")




hypothesis = inHypsFile.readlines()
#print(hypothesis)
#cleanhypothesis = [l.replace(",", "").strip() for l in hypothesis if l.strip()]  #original obs (use for precondition)
cleanhypothesis = [l.split(",") for l in hypothesis if l.strip()]  #original obs (use for precondition)
#print(cleanhypothesis)


#cleanhypothesis = cleanhypothesis.replace(",", " ")

#print "clean hypothesis %d", cleanhypothesis

lines = inDomainFile.readlines()
cleanLines = [l.strip() for l in lines if l.strip()]

notAddedGoalActions = True

for line in cleanLines:
    org = line
    outDomain.write(org)
    outDomain.write("\n")



#### Problem Related
lines = inProblemFile.readlines()
cleanLines = [l.strip() for l in lines if l.strip()]

for line in cleanLines:
    org =  line

    if (line != "" and line.find("<") != -1):
        org = ""
      
    if (line.find("<HYPOTHESIS>") != -1):
    		continue

    outProblem.write(org)
    outProblem.write("\n")





inProblemFile.close()
outProblem.close()
inDomainFile.close()
outDomain.close()




