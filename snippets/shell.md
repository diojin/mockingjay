## Index
___

* [Miscellaneous](#miscellaneous)
    - [find](#find)
    - [su](#su)
    - [create user](#create-user)
    - [change user's primary group(login group)](#change-users-primary-grouplogin-group)

___


## Miscellaneous
### find


### su
* swither to root

>The su utility requests appropriate user credentials via PAM and switches to that user ID (the default user is the superuser).
-l      Simulate a full login.  The environment is discarded except for HOME, SHELL, PATH, TERM, and USER.  HOME and SHELL are modified as above.  USER is set to the target login.  PATH is set to ``/bin:/usr/bin''.  TERM is imported from your current environment.  The invoked shell is the target login's, and su will change directory to the target login's home directory.
-       (no letter) The same as -l.

```shell
sudo su -

```

### create user
```shell
> su
> useradd -m hadoop -g root -s /bin/bash
# setup password
> passwd hadoop 
# add user hadoop as administrator
> visudo            #  equals to "vi /etc/sudoers"
root ALL=(ALL) ALL 
hadoop ALL=(ALL) ALL （use tab as space）
```

-g primary group/login group  
-G supplymentary group  

When you use the -G option with useradd, you should also use the -a option to append new groups to the current list of supplementary groups that user 'hadoop' belongs. Without the -a option you will replace current supplementary groups with a new group set. Therefore use this cautiously.

### change user's primary group(login group)
```shell
usermod -g {new_group} {user_name}
```

