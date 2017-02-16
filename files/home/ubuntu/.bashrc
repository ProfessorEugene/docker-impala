# Enable core dumps.
ulimit -c unlimited

# On some systems regular users don't
# have /sbin in their path by default but /sbin useful and all users have sudo.
PATH="${PATH}:/sbin"

# The data loading will be done by the dev user and hadoop permissions will fail if the
# user is not "dev". Without explicitly overriding this, the $USER on some OSs (ex:
# Ubuntu) would be the user name used to SSH in.
USER=dev

# In case this script is not run through SSH, use the $HOME dir to get what would be
# the SSH user name.
export SSH_USER=$(basename $HOME)

if [[ -f /etc/bash_completion.d ]]; then
  . /etc/bash_completion.d
fi

if [[ -f $HOME/.extra_bashrc ]]; then
  . $HOME/.extra_bashrc
fi
