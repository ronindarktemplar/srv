__virtualname__ = 'noredhat'

def __virtual__():
  if __grains__['os_family'] == 'RedHat':
      return False
  return __virtualname__

__virtualname__ = 'nowin'

def __virtual__():
  if __grains__['os_family'] == 'Windows':
      return False
  return __virtualname__


def users_as_csv():
  '''
  SaltConf15 - SaltStack - Extending SaltStack with Custom Execution and Runner Modules
  Link: https://www.youtube.com/watch?v=7CxJGglQhxQ
  '''
  user_list = __salt__['user.list_users']()
  csv = ','.join(user_list)
  return csv

