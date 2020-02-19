# Threefold-Circles-Flist

https://hub.grid.tf/tf-autobuilder/threefoldtech-Threefold-Circles-Flist-autostart-master.flist


- note server only work with https due to threebot login require this 

- you should set all below env variables when create the container and use the domain naming instead ip address in HOST_IP as below 

- env variables are : SECRET_KEY , EMAIL_HOST, EMAIL_HOST_USER, EMAIL_HOST_PASSWORD, HOST_IP, HTTP_PORT=80

- also you need configure restic env variables : RESTIC_REPOSITORY AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY RESTIC_PASSWORD"


```
container.py create -n 10.102.251.225 -iyocl 9Xk-WsnhkPi8c9 --clientsecret GjT \ 
-f https://hub.grid.tf/tf-autobuilder/threefoldtech-Threefold-Circles-Flist-autostart-master.flist \ 
--sshkey 'ssh-rsa  AAAAB3NzaC1yc2EAAAADAQABAAABAQC8o0jEGYqe2k7J0TNL6Gg8h86ic3ReiC6THlBnOKPDiKProj/4uMTmi1Qf5OcLIdeHgcP+zy+ZL4kpP7N6VTALRPiTn6Lty6ZP+5mQocaJYosoGLzB6+lx1NW/zXtscv4V3goULiDEx9SBzSuD8wS0k00iHcRjmuFUIfERyYR8mjmWC/sRf1Y7qk9kQjFOLW5Sw0+RLrxr4l2ur/n8bDVgGVpzWypKIsqRU6Rf1HdXWmdAMCucPAkxR5WNies5QFOkyllxI6Fq+G9M0Uf+EubpfpC1oOMWjNFy781M4KZF+FXODcBlwevfvk0HH/5mTHOymIfwVV8vjRzycxjuQib3 pishoy@Bishoy-laptop' \ -p '2222:22' -p '80:80' --name tiaga_test -envs SECRET_KEY=myscret -envs EMAIL_HOST=test.smtp.com \ 
-p '2222:22' -p '80:80' --name tiaga_test -envs SECRET_KEY=myscret -envs EMAIL_HOST=test@test.com \ 
-envs  RESTIC_REPOSITORY="s3:https://s3.grid.tf/taiga-test" -envs AWS_ACCESS_KEY_ID="myaccessid" \ 
-envs AWS_SECRET_ACCESS_KEY="myscret" -envs RESTIC_PASSWORD="mypass"

```


- create your ur https redirection in caddy server 

```

https://test.circles.com {
        proxy / 10.102.251.225:80 {
                transparent
        }
}

http://test.circles.com {
    redir https://test.circles.com{uri}
}

```
