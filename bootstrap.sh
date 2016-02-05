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
lnif $endpath/.tmux.conf $HOME/.tmux.conf
lnif $endpath/.tern-config $HOME/.tern-config
lnif $endpath/.vimrc.bundles $HOME/.vimrc.bundles
lnif $endpath/.ctags $HOME/.ctags
lnif $endpath/.global_ignore $HOME/.global_ignore
# nvim link
lnif $endpath $HOME/.config/nvim
lnif $endpath/.vimrc $endpath/init.vim

if [ ! -d $endpath/.vim/bundle ]; then
  mkdir -p $endpath/.vim/bundle
fi

if [ ! -e $HOME/.vim/autoload/plug.vim ]; then
  echo "Installing vim-plug"
  curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# echo "update/install plugins using vim-plug"
# system_shell=$SHELL
# export SHELL="/bin/sh"
# nvim +PluginInstall! +PluginClean +qall
# export SHELL=$system_shell
git config --global core.excludesfile $HOME/.global_ignore
echo "Welcome to vim power. Happy coding!!!"
