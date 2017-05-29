##Index
___



* [Miscellaneous](#miscellaneous)
    - [find](#find)
    - [su](#su)

___


Miscellaneous
---
####find


####su
* swither to root

>The su utility requests appropriate user credentials via PAM and switches to that user ID (the default user is the superuser).
-l      Simulate a full login.  The environment is discarded except for HOME, SHELL, PATH, TERM, and USER.  HOME and SHELL are modified as above.  USER is set to the target login.  PATH is set to ``/bin:/usr/bin''.  TERM is imported from your current environment.  The invoked shell is the target login's, and su will change directory to the target login's home directory.
-       (no letter) The same as -l.


```shell
sudo su -

```