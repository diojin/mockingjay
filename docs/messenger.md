
https://gist.github.com/nightire/5069597
https://segmentfault.com/a/1190000000578037

eclipse & intellij install scala
http://www.linuxidc.com/Linux/2015-08/120946.htm
http://www.07net01.com/2016/02/1251482.html
http://scala-ide.org/download/current.html
快速编译scala
http://blog.csdn.net/maosidiaoxian/article/details/45476579

gradle eclipse support
buildship from eclipse market place
http://my.oschina.net/moziqi/blog/308842

eclipse中使用Lombok
https://segmentfault.com/n/1330000003805656
http://www.360doc.com/content/15/0922/13/1180274_500690950.shtml

lombok官网 https://projectlombok.org/download.html
1.官网下载lombok.jar
2. 找到Eclipse应用（在Mac上就是Eclipse.app文件），选择打开包内容，找到eclipse.ini
3.将lombok.jar拷贝至eclipse.ini所在目录下，并在eclipse.ini文件最后加上如下两行
-Xbootclasspath/a:lombok.jar
-javaagent:/Users/abc/Eclipse/eclipse-jee-mars-1-macosx-cocoa-         
     x86_64/Eclipse.app/Contents/Eclipse/lombok.jar
4.重启eclipse

Mac下lombok无法安装到eclipse mars
http://www.cnblogs.com/taojintianxia/p/4828263.html
