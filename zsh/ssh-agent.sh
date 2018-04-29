# Handle the complexities of dealing with SSH
# and starting the agent up automatically.

ZSH_SSH_ENV="${HOME}/.ssh/environment"
ZSH_SSH_CONFIG="${HOME}/.zsh-ssh"


function ssh_load_identities() {
  ssh-add -l | grep "no identities" > /dev/null
  if [ $? -eq 0 ]; then
    ssh_reload_identities
  fi
}

function ssh_reload_identities() {
  if [ -f "${ZSH_SSH_CONFIG}" ]; then
    . "${ZSH_SSH_CONFIG}" > /dev/null
  fi
  if [ -n "${ZSH_SSH_IDENTITIES}" ]; then
    echo "${ZSH_SSH_IDENTITIES}" | xargs ssh-add
  fi
}

function ssh_start_agent() {
  echo "Initializing SSH agent"
  ssh-agent | sed 's/^echo/#echo/' > ${ZSH_SSH_ENV}
  echo "SSH Agent loaded"
  chmod 600 ${ZSH_SSH_ENV}
  . "${ZSH_SSH_ENV}" > /dev/null
  ssh-add
}

function ssh_test_identities() {
  ssh-add -l | grep "no identities" > /dev/null
  if [ $? -eq 0 ]; then
    ssh-add
    if [ $? -eq 2 ]; then
      echo "Starting new agent"
      ssh_start_agent
    fi
  fi
}

# Check for an active ssh-agent with a valid SSH_AGENT_PID
# value set.
if [ -n "${SSH_AGENT_PID}" ]; then
  ps ef | grep "${SSH_AGENT_PID}" | grep ssh-agent > /dev/null
  if [ $? -eq 0 ]; then
    ssh_test_identities
  fi
else
  echo "Attempting to load ssh-agent from SSH environment"
  if [ -f "${ZSH_SSH_ENV}" ]; then
    . "${ZSH_SSH_ENV}" > /dev/null
  else
    echo "No SSH environment found. Starting new agent"
    ssh_start_agent
  fi
  ps -ef | grep "${SSH_AGENT_PID}" | grep -v grep | grep ssh-agent > /dev/null
  if [ $? -eq 0 ]; then
    ssh_test_identities
  else
    ssh_start_agent
  fi
fi
if [ -n "${SSH_AGENT_PID}" ]; then
  ps ef | grep "${SSH_AGENT_PID}" | grep ssh-agent > /dev/null
  if [ $? -eq 0 ]; then
    echo "Successfully loaded SSH agent"
    ssh_load_identities
  else
    echo "Failed to load SSH agent"
  fi
else
    echo "Failed to load SSH agent"
fi


