#!/usr/bin/python2.7

import sys
import os
#from sets import Set

DFILE_KEYWORDS = ["requirements", "types", "predicates", "durative-action", "private","functions","constants"]
DFILE_REQ_KEYWORDS = ["typing","strips","multi-agent","unfactored-privacy", "durative-actions"]
DFILE_SUBKEYWORDS = ["parameters", "precondition", "effect", "duration"]
PFILE_KEYWORDS = ["objects", "init", "goal","private","metric"]
AFILE_KEYWORDS = ["agents"]
TEMPORAL_DESCRIPTORS = ["at start", "at end", "over all"]

FORBIDDEN_PREDS = ["increase", "="]

verbose = False


class Predicate(object):
  """A loose interpretation of a predicate used for all similar collections.

  Without a name it is a parameter list.
  It can be typed (or not).
    If typed then args = [[var, type], ...]
    Else args = [var, ...]
  It can be negated.
  It may contain variables or objects in its arguments.
  """
  def __init__(self, name, args, is_typed, is_negated, is_temp_cond = False, temp_attr = 0):
    self.name = name
    self.args = args
    self.temp_attr = temp_attr
    self.arity = len(args)
    self.is_typed = is_typed
    self.is_negated = is_negated
    self.is_temp_cond = is_temp_cond
    self.ground_facts = set()
    self.agent_param = -1

  def pddl_rep(self):
    """Returns the PDDL version of the instance."""
    rep = ''
    if self.temp_attr != 0:
      rep += "(" + self.temp_attr	
    if self.is_negated:
      rep += "(not "
    if self.name != "":
      rep += "(" + self.name + " "
    else:
      rep += "("
    for argument in self.args:
      if self.is_typed:
        rep += argument[0] + " - " + argument[1] + " "
      else:
        rep += argument + " "
    rep = rep[:-1]
    rep += ")"
    if self.is_negated:
      rep += ")"
    if self.is_temp_cond:
      rep += ")"
    return rep
  
  def ground(mapping):
    assert all([v[0] in mapping for v in self.args]), "Error: Trying to ground an already ground predicate " + str(self)
    return Predicate(self.name, [mapping[v[0]] for v in self.args], False, False)
      

  def __repr__(self):
    return self.pddl_rep()

  def __eq__(self, other) :
    if self.name != other.name : return False
    if len(self.args) != len(other.args) : return False
    for i in xrange(len(self.args)) :
      if self.args[i] != other.args[i] : return False
    return True

  def __ne__(self, other ) :
    return  not self.__eq__(other)
  
  def __hash__(self):
    return hash(str(self))


class Action(object):
  """Represents a simple non-temporal action."""
  def __init__(self, name, parameters, precondition, effect, ag, agt, duration):
    self.name = name
    self.parameters = parameters
    self.precondition = precondition
    self.effect = effect
    self.duration = duration
    self.agent = ag[0]
    self.agent_type = agt

  def pddl_rep(self):
    """Returns the PDDL version of the instance."""

    arguments = [item[0] for item in self.parameters.args]

    # Must also have access to the predicates
    toadd = set()
    #print "\nAction: " + self.name
    for pred in self.precondition + self.effect:
      if pred.name not in FORBIDDEN_PREDS:
        if self.agent[0] in pred.args:
          #print(pred.name)
          toadd.add(Predicate('K-ag-pred', [self.agent[0], 'pred--'+pred.name], False, False, True, "at start"))
          #toadd.add(Predicate('K-ag-pred', [self.agent[0], 'pred--'+pred.name], False, False, True))
          #print "+" + str(pred)
        else:
          toadd.add(Predicate('K-pred', [self.agent[0], 'pred--'+pred.name], False, False, True, "at start"))
          #toadd.add(Predicate('K-pred', [self.agent[0], 'pred--'+pred.name], False, False, True))
          #print "-" + str(pred)
    
    self.precondition.extend(list(toadd))

    # Must have access to the objects
    for arg in arguments:
      # Assumption -- an agent never needs to know about themself
      if self.agent[0] != arg:
          self.precondition.append(Predicate("K-obj", [self.agent[0], arg], False, False, True, "at start"))

    rep = ''
    rep += "(:durative-action " + self.name + "\n"
    rep += "\t:parameters " + str(self.parameters) + "\n"
    rep += "\t:duration (= ?duration {0})".format(self.duration) + "\n" #rep += "\t:duration (= ?duration {0})".format(str ( int(self.duration) + 10)    ) + "\n"
    if len(self.precondition) > 1:
      rep += "\t:condition (and\n"
    else:
      rep += "\t:condition \n"
    for precon in self.precondition:
      rep += "\t\t" + str(precon) + "\n"
    if len(self.precondition) > 1:
      rep += "\t)\n"
    if len(self.effect) > 1:
      rep += "\t:effect (and\n"
    else:
      rep += "\t:effect \n"
    for eff in self.effect:
      rep += "\t\t" + str(eff) + "\n"
    if len(self.effect) > 1:
      rep += "\t)\n"
    rep += ")\n"
    return rep

  def __repr__(self):
    return self.name #+ str(self.parameters)

class Function(object):
  def __init__(self, obj_list):
    self.obj_list = obj_list

  def pddl_rep(self):
    """Returns the PDDL version of the instance."""
    rep = '('
    for argument in self.obj_list:
      rep += argument + " "
    rep = rep[:-1]
    rep += ") - number"
    return rep

  def __repr__(self):
    return self.pddl_rep()

class GroundFunction(object):
  def __init__(self, obj_list):
    self.obj_list = obj_list

  def pddl_rep(self):
    """Returns the PDDL version of the instance."""
    rep = '(' + self.obj_list[0] + " ("
    for argument in self.obj_list[1:-1]:
      rep += argument + " "
    rep = rep[:-1]
    rep += ") " + self.obj_list[-1] + ") "
    return rep

  def __repr__(self):
    return self.pddl_rep()



class PlanningProblem(object):
  def __init__(self, domainfile, problemfile):
    self.domain = '' #String
    self.requirements = set() #[String]
    self.type_list = set() #{String}
    self.type_list.add('object')
    self.types = {} #Key = supertype_name, Value = type
    self.predicates = [] #[Predicate]
    self.functions = []
    self.ground_functions = []
    self.actions = [] #[Action]
    self.agent_types = set()
    self.agents = set()
    self.problem = '' #String
    self.object_list = set() #{String}
    self.objects = {} #Key = type, Value = object_name
    self.private_objects = {} #Key = agent, Value = object_name
    self.public_objects = []
    self.public_predicates = []
    self.constants = {} #Key = type, Value = object_name
    self.init = [] #List of Predicates
    self.goal = [] #List of Predicates
    self.metric = False

    self.parse_domain(domainfile)
    self.parse_problem(problemfile)

    orig_constants = []
    if len( self.constants.values() ) > 0:
      orig_constants = reduce(lambda x,y: x+y, self.constants.values())

    self.constants['superduperpred'] = []
    for pred in self.predicates:
      self.constants['superduperpred'].append('pred--'+pred.name)
      
    self.predicates.append(Predicate('K-obj', [('?ag','superduperagent'), ('?obj','superduperobject')], True, False))
    self.predicates.append(Predicate('K-pred', [('?ag','superduperagent'), ('?pr','superduperpred')], True, False))
    self.predicates.append(Predicate('K-ag-pred', [('?ag','superduperagent'), ('?pr','superduperpred')], True, False))

    #print "\nPrivate Objects: " + str(self.private_objects)
    #print "\nPublic Objects: " + str(self.public_objects)
    #print "\nPrivate Predicates: " + str(self.priv_pred_mapping)
   # print

    self.types['superduperagent'] = []
    for t in self.agent_types:
      self.types['superduperagent'].append(t)
      self.agents = self.agents | self.get_objects_of_type(t)
    
    
    self.types['superduperobject'] = self.type_list
    #self.types['superduperpred'] = []
    self.type_list.add('superduperagent')
    self.type_list.add('superduperobject')
    self.type_list.add('superduperpred')
    for t in self.types:
      assert t in self.type_list

    for a in self.agents:
      for o in self.public_objects + orig_constants:
        self.init.append(Predicate('K-obj', [a, o], False, False))

    for a in self.private_objects:
      for o in self.private_objects[a]:
        self.init.append(Predicate('K-obj', [a, o], False, False))
    
    for at in self.priv_pred_mapping:
      assert 3 == len(at), "Error: private predicate defined by an untyped agent!"
      for a in self.get_objects_of_type(at[2]):
        for pred in self.priv_pred_mapping[at]:
          self.init.append(Predicate('K-ag-pred', [a, 'pred--'+pred.name], False, False))
          if at[0] not in [arg[0] for arg in pred.args]:
            self.init.append(Predicate('K-pred', [a, 'pred--'+pred.name], False, False))
    
    for pred in self.public_predicates:
       for a in self.agents:
         self.init.append(Predicate('K-ag-pred', [a, 'pred--'+pred.name], False, False))
         self.init.append(Predicate('K-pred', [a, 'pred--'+pred.name], False, False))
    
    #print '\n'.join(map(str, self.init))
    #assert False

    self.requirements.remove("multi-agent") #= self.requirements - {"multi-agent","unfactored-privacy"}
    self.requirements.remove("unfactored-privacy")

  def parse_domain(self, domainfile):
    """Parses a PDDL domain file."""

    with open(domainfile) as dfile:
      dfile_array = self._get_file_as_array(dfile)
    #Deal with front/end define, problem, :domain
    if dfile_array[0:4] != ['(', 'define', '(', 'domain']:
      print 'PARSING ERROR: Expected (define (domain ... at start of domain file'
      sys.exit()
    self.domain = dfile_array[4]

    dfile_array = dfile_array[6:-1]
    opencounter = 0
    keyword = ''
    obj_list = []
    is_obj_list = True
    priv_agent = False
    self.priv_pred_mapping = {}
    for word in dfile_array:
      #print(word)
      #print(opencounter)
      if word == '(':
        opencounter += 1
      elif word == ')':
        opencounter -= 1
      elif word.startswith(':'):
        if word[1:] not in DFILE_KEYWORDS:
          pass
        elif keyword != 'requirements':
          keyword = word[1:]
          #print(keyword)
         
      if opencounter == 0:
        
        if keyword == 'durative-action':
          self.actions.append(obj_list)
          obj_list = []
        if keyword == 'types':
          for element in obj_list:
            self.types.setdefault('object', []).append(element)
            self.type_list.add('object')
            self.type_list.add(element)
          obj_list = []
        keyword = ''

      if keyword == 'requirements': #Requirements list
        if word != ':requirements':
          if not word.startswith(':'):
            print 'PARSING ERROR: Expected requirement to start with :'
            sys.exit()
          elif word[1:] not in DFILE_REQ_KEYWORDS:
            print 'WARNING: Unknown Rquierement ' + word[1:]
            #print 'Requirements must only be: ' + str(DFILE_REQ_KEYWORDS)
            #sys.exit()
          else:
            self.requirements.add(word[1:])
      elif keyword == 'durative-action':
        obj_list.append(word)
        #print(word)
      elif not word.startswith(':'):
        if keyword == 'types': #Typed list of objects
          if is_obj_list:
            if word == '-':
              is_obj_list = False
            else:
              obj_list.append(word)
          else:
            #word is type
            for element in obj_list:
              if not word in self.type_list:
                self.types.setdefault('object', []).append(word)
                self.type_list.add(word)
              self.types.setdefault(word, []).append(element)
              self.type_list.add(element)
              self.type_list.add(word)
            is_obj_list = True
            obj_list = []
        elif keyword == 'constants': #Typed list of objects
          if is_obj_list:
            if word == '-':
              is_obj_list = False
            else:
              obj_list.append(word)
          else:
            #word is type
            for element in obj_list:
              if word in self.type_list:
                self.constants.setdefault(word, []).append(element)
                #self.object_list.add(element)
              else:
                print self.type_list
                print "ERROR unknown type " + word
                sys.exit()
            is_obj_list = True
            obj_list = []
        elif keyword == 'predicates' or keyword == 'private': #Internally typed predicates
          if word == ')':
            if keyword == 'private':
              priv_agent = tuple(obj_list[:3])
              #print "...skip agent: " +  str(priv_agent)
              if priv_agent not in self.priv_pred_mapping:
                self.priv_pred_mapping[priv_agent] = []
              obj_list = obj_list[3:]
              keyword = 'predicates'
            if len(obj_list) == 0:
              #print "...skip )"
              continue
            p_name = obj_list[0]
            #print "parse predicate: " + p_name + " " + str(obj_list)
            pred_list = self._parse_name_type_pairs(obj_list[1:],self.type_list)
            new_predicate = Predicate(p_name, pred_list, True, False)
            if new_predicate not in self.predicates : self.predicates.append(new_predicate)
            if priv_agent:
              self.priv_pred_mapping[priv_agent].append(new_predicate)
            else:
              self.public_predicates.append(new_predicate)
            obj_list = []
          elif word != '(':
            obj_list.append(word)
        elif keyword == 'functions': #functions
          if word == ')':
            p_name = obj_list[0]
            if obj_list[0] == '-':
              obj_list = obj_list[2:]
            #print "function: " + word + " - " + str(obj_list)
            self.functions.append(Function(obj_list))
            obj_list = []
          elif word != '(':
            obj_list.append(word)


    #Work on the actions
    new_actions = []
    for action in self.actions:
      #print(action)
      if action[0] == '-':
        action = action[2:]
      act_name = action[1]
      act = {}
      action = action[2:]
      keyword = ''
      for word in action:
        if word.startswith(':'):
          keyword = word[1:]
        else:
          act.setdefault(keyword, []).append(word)
      self.agent_types.add(act.get('agent')[2])
      agent = self._parse_name_type_pairs(act.get('agent'),self.type_list)
      param_list = agent + self._parse_name_type_pairs(act.get('parameters')[1:-1],self.type_list)
      up_params = Predicate('', param_list, True, False)
      pre_list = self._parse_unground_propositions(act.get('condition'))
      eff_list = self._parse_unground_propositions(act.get('effect'))
      duration = act.get('duration')[3]
      
      new_act = Action(act_name, up_params, pre_list, eff_list, agent, act.get('agent')[2], duration) 
      
      new_actions.append(new_act)
      
    self.actions = new_actions

  def parse_problem(self, problemfile):
    """The main method for parsing a PDDL files."""

    with open(problemfile) as pfile:
      pfile_array = self._get_file_as_array(pfile)
    #Deal with front/end define, problem, :domain
    if pfile_array[0:4] != ['(', 'define', '(', 'problem']:
      print 'PARSING ERROR: Expected (define (problem ... at start of problem file'
      sys.exit()
    self.problem = pfile_array[4]
    if pfile_array[5:8] != [')', '(', ':domain']:
      print 'PARSING ERROR: Expected (:domain ...) after (define (problem ...)'
      sys.exit()
    if self.domain != pfile_array[8]:
      print 'ERROR - names don\'t match between domain and problem file.'
      #sys.exit()
    if pfile_array[9] != ')':
      print 'PARSING ERROR: Expected end of domain declaration'
      sys.exit()
    pfile_array = pfile_array[10:-1]

    opencounter = 0
    keyword = ''
    is_obj_list = True
    is_function = False
    obj_list = []
    int_obj_list = []
    int_opencounter = 0
    priv_agent = False
    for word in pfile_array:
      if word == '(':
        opencounter += 1
      elif word == ')':
        if keyword == 'objects':
          obj_list = []
        opencounter -= 1
      elif word.startswith(':'):
        if word[1:] not in PFILE_KEYWORDS:
          print 'PARSING ERROR: Unknown keyword: ' + word[1:]
          print 'Known keywords: ' + str(PFILE_KEYWORDS)
        else:
          keyword = word[1:]
          if keyword == 'objects':
            priv_agent = False
      if opencounter == 0:
        keyword = ''

      if not word.startswith(':'):
        if keyword == 'objects' or keyword == 'private': #Typed list of objects
          #print "word: " + word
          #print "obj_list: " + str(obj_list)
          if keyword == 'private':
              #print "...skip agent: " +  word
              obj_list = []
              keyword = 'objects'
              priv_agent = word
              continue
          if is_obj_list:
            if word == '-':
              is_obj_list = False
            else:
              obj_list.append(word)
          else:
            #word is type
            if priv_agent:
              self.private_objects.setdefault(priv_agent, []).extend(obj_list)
            else:
              self.public_objects.extend(obj_list)
            for element in obj_list:
              if word in self.type_list:
                self.objects.setdefault(word, []).append(element)
                self.object_list.add(element)
              else:
                print self.type_list
                print "ERROR unknown type " + word
                sys.exit()
            is_obj_list = True
            obj_list = []
        elif keyword == 'init':
           if word == ')':
             if obj_list[0] == '=' and is_function == False:
               is_function = True
             else:
               if is_function:
                 #print "function: " + str(obj_list)
                 self.ground_functions.append(GroundFunction(obj_list))
                 is_function = False
               else:
                 #print "predicate: " + str(obj_list)
                 self.init.append(Predicate(obj_list[0], obj_list[1:],False, False))
               obj_list = []
           elif word != '(':
             obj_list.append(word)
        elif keyword == 'goal':
          if word == '(':
            int_opencounter += 1
          elif word == ')':
            int_opencounter -= 1
          obj_list.append(word)
          if int_opencounter == 0:
              self.goal = self._parse_unground_propositions(obj_list)
              obj_list = []
        elif keyword == 'metric':
          self.metric = True
          obj_list = []

  def get_type_of_object(self,obj):
    for t in self.objects.iterkeys():
      if obj in self.objects[t]:
        return t
    for t in self.constants.iterkeys():
      if obj in self.constants[t]:
        return t

  def get_objects_of_type(self,of_type):
    #print "get objects of type " + of_type
    selected_types = set()
    selected_types.add(of_type)  #CHANGED BECAUSE OF PYTHON VERSION DIFFS
  	
    pre_size = 0
    while len(selected_types) > pre_size:
      pre_size = len(selected_types)
      for t in selected_types:
        if t in self.types:
          selected_types = selected_types | set(self.types[t])
    #print selected_types
    selected_objects = set()
    for t in selected_types:
      if t in self.objects:
        selected_objects = selected_objects | set(self.objects[t])
      if t in self.constants:
        selected_objects = selected_objects | set(self.constants[t])
    return selected_objects

  def print_domain(self):
    """Prints out the planning problem in (semi-)readable format."""
    print '\n*****************'
    print 'DOMAIN: ' + self.domain
    print 'REQUIREMENTS: ' + str(self.requirements)
    print 'TYPES: ' + str(self.types)
    print 'PREDICATES: ' + str(self.predicates)
    print 'ACTIONS: ' + str(self.actions)
    print 'FUNCTIONS: ' + str(self.functions)
    print 'CONSTANTS: ' + str(self.constants)
    print '****************'

  def print_problem(self):
    """Prints out the planning problem in (semi-)readable format."""
    print '\n*****************'
    print 'PROBLEM: ' + self.problem
    print 'OBJECTS: ' + str(self.objects)
    print 'INIT: ' + str(self.init)
    print 'GOAL: ' + str(self.goal)
    print 'AGENTS: ' + str(self.agents)
    print '****************'





  #Get string of file with comments removed - comments are rest of line after ';'
  def _get_file_as_array(self, file_):
    """Returns the file split into array of words.

    Removes comments and separates parenthesis.
    """
    file_as_string = ""
    for line in file_:
      if ";" in line:
        line = line[:line.find(";")]
      line = (line.replace('\t', '').replace('\n', ' ')
          .replace('(', ' ( ').replace(')', ' ) '))
      file_as_string += line
    file_.close()
    return file_as_string.strip().split()

  def _parse_name_type_pairs(self, array, types):
    """Parses array creating paris of form (name, type).

    Expects array such as [?a, -, agent, ...]."""
    pred_list = []
    if len(array)%3 != 0:
      print "Expected predicate to be typed " + str(array)
      sys.exit()
    for i in range(0, len(array)/3):
      if array[3*i+1] != '-':
        print "Expected predicate to be typed"
        sys.exit()
      if array[3*i+2] in types:
        pred_list.append((array[3*i], array[3*i+2]))
      else:
        print "PARSING ERROR {0} not in types list".format(array[3*i+2])
        print "Types list: {0}".format(self.type_list)
        sys.exit()
    return pred_list

  def _parse_unground_proposition(self, array):
    """Parses a variable proposition returning dict."""
    negative = False
    if array[1] + " " + array[2] in TEMPORAL_DESCRIPTORS:
      temp_desc = array[1] + " " + array[2]
      if array[4] == 'not':
        negative = True
        array = array[5:-1]
        pred = Predicate(array[1], array[2:-1], False, negative, False, temp_desc)
      else:
        pred = Predicate(array[4], array[5:-1], False, negative, False, temp_desc)
    else:
      if array[1] == 'not':
        negative = True
        array = array[2:-1] 
      pred =  Predicate(array[1], array[2:-1], False, negative)
    #print(pred)  
    return pred

  def _parse_unground_propositions(self, array):
    """Parses possibly conjunctive list of unground propositions.

    Expects array such as [(and, (, at, ?a, ?x, ), ...].
    """
    prop_list = []
    if array[0:3] == ['(', 'and', '(']:
      array = array[2:-1]
    #Split array into blocks
    opencounter = 0
    prop = []
    for word in array:
      
      if word == '(':
        opencounter += 1
      if word == ')':
        opencounter -= 1
      prop.append(word)
      if opencounter == 0:
        prop_list.append(self._parse_unground_proposition(prop))
        prop = []
    #print array[:array.index(')') + 1]
    #print(prop_list)
    return prop_list

  def write_pddl_domain(self, output_file):
    """Writes an unfactored MA-PDDL domain file for this planning problem."""
    file_ = open(output_file, 'w')
    to_write = "(define (domain " + self.domain + ")\n"
    #Requirements
    to_write += "\t(:requirements"
    for r in self.requirements:
      to_write += " :"+r
    to_write += ")\n"
    #Types
    to_write += "(:types\n"
    for type_ in self.types:
      to_write += "\t"
      for key in self.types.get(type_):
        to_write += key + " "
      to_write += "- " + type_
      to_write += "\n"
    to_write += ")\n"
    #Constants
    if len(self.constants) > 0:
      to_write += "(:constants\n"
      for t in self.constants.iterkeys():
        to_write += "\t"
        for c in self.constants[t]:
          to_write += c + " "
        to_write += " - " + t + "\n"
      to_write += ")\n"
    #Public predicates
    to_write += "(:predicates\n"
    for predicate in self.predicates:
      to_write += "\t{0}\n".format(predicate.pddl_rep())
    to_write += ")\n"
    #Functions
    if len(self.functions) > 0:
      to_write += "(:functions\n"
      for function in self.functions:
        to_write += "\t{0}\n".format(function.pddl_rep())
      to_write += ")\n"
    #Actions
    for action in self.actions:
      to_write += "\n{0}\n".format(action.pddl_rep())

    #Endmatter
    to_write += ")" #Close domain defn
    file_.write(to_write)
    file_.close()

  def write_pddl_problem(self, output_file):
    file_ = open(output_file, 'w')
    to_write = "(define (problem " + self.problem +") "
    to_write += "(:domain " + self.domain + ")\n"
    #Objects
    to_write += "(:objects\n"
    for obj in self.object_list:
      to_write += "\t" + obj + " - " + self.get_type_of_object(obj) + "\n"
    to_write += ")\n"
    to_write += "(:init\n"
    for predicate in self.init:
      to_write += "\t{0}\n".format(predicate)
    for function in self.ground_functions:
      to_write += "\t{0}\n".format(function)
    to_write += ")\n"
    to_write += "(:goal\t(and\n"
    for goal in self.goal:
      to_write += "\t\t{0}\n".format(goal)
    to_write += "\t)\n)\n"
    if 1:#self.metric:
      to_write += "(:metric minimize (total-time))\n"
    #Endmatter
    to_write += ")"
    file_.write(to_write)
    file_.close()

  def write_addl(self, output_file):
    file_ = open(output_file, 'w')
    to_write = "(define (problem " + self.problem +") "
    to_write += "(:domain " + self.domain + ")\n"
    #Objects
    to_write += "(:agents"
    for obj in self.agents:
      to_write += " " + obj
    to_write += ")\n"
    to_write += ")"
    file_.write(to_write)
    file_.close()

  def write_agent_list(self, output_file):
    file_ = open(output_file, 'w')
    to_write = ""
    for obj in self.agents:
      to_write += obj + "\n"
    file_.write(to_write)
    file_.close()



def compile_away_ma(domain_file, problem_file, path_to_dir = "0", penalty = 'penalty_off'):
	pp = PlanningProblem(domain_file, problem_file)
	max_duration =  max ([int(action.duration) for action in pp.actions])
	if penalty == 'penalty_on':
		for action in pp.actions:
			action.duration = str ( int(action.duration) + max_duration)
	

	if verbose:
		pp.print_domain()
		pp.print_problem()

	if path_to_dir != "0":
		pp.write_pddl_domain(path_to_dir + "/k-domain.pddl")
		pp.write_pddl_problem(path_to_dir + "/k-problem.pddl")
	else:
		pp.write_pddl_domain('k-domain.pddl')
		pp.write_pddl_problem('k-problem.pddl')
		
	return pp, max_duration





