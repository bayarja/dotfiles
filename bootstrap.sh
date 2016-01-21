#! /usr/bin/env sh
lnif() {
    if [ ! -e $2 ] ; then
        ln -s $1 $2
    fi
    if [ -L $2 ] ; then
        ln -sf $1 $2
    fi
}

endpath="$HOME/.vim"

if [ ! -e $endpath/.git ]; then
    echo "cloning vim config"
    git clone --recursive -b master https://github.com/Orgil/dotfiles.git $endpath
else
    echo "updating vim config"
    cd $endpath && git pull origin master
fi

echo "setting up symlinks"
lnif $endpath/.vimrc $HOME/.vimrc
lnif $endpath/.vimrc $HOME/init.vim
lnif $endpath/.tmux.conf $HOME/.tmux.conf
lnif $endpath/.tern-config $HOME/.tern-config
lnif $endpath/.vimrc.bundles $HOME/.vimrc.bundles
lnif $endpath/.ctags $HOME/.ctags
lnif $endpath/.global_ignore $HOME/.global_ignore
if [ ! -d $endpath/.vim/bundle ]; then
  mkdir -p $endpath/.vim/bundle
fi

if [ ! -e $HOME/.vim/bundle/Vundle.vim ]; then
  echo "Installing Vundle"
  git clone https://github.com/gmarik/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
fi

echo "update/install plugins using Vundle"
system_shell=$SHELL
export SHELL="/bin/sh"
vim +PluginInstall! +PluginClean +qall
export SHELL=$system_shell
git config --global core.excludesfile $HOME/.global_ignore
echo "Welcome to vim power. Happy coding!!!"
