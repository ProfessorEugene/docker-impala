# Enable core dumps.
ulimit -c unlimited

# Add the user's bin dir and the Impala bin dirs. On some systems regular user don't
# have /sbin in their path by default but /sbin useful and all users have sudo.
PATH="$PATH:/sbin"

# The data loading will be done by the dev user and hadoop permissions will fail if the
# user is not "dev". Without explicitly overriding this, the $USER on some OSs (ex:
# Ubuntu) would be the user name used to SSH in.
USER=dev

# In case this script is not run through SSH, use the $HOME dir to get what would be
# the SSH user name.
export SSH_USER=$(basename $HOME)

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

if [[ -f $HOME/.extra_zshrc ]]; then
  source $HOME/.extra_zshrc
fi
