<h3>overlayFS简单实战</h3>
<p>1.如何判断内核中加载了overlay<br />
<code>root@qa-control-pub-ci-build1:~# lsmod |grep over overlay 28140 0</code><br />
如果没有加载的话，则使用如下命令加载<code>modprobe overlay</code></p>
<p>2.挂载overlayfs文件系统 创建几个文件夹如下所示</p>
<pre><code>root@qa-control-pub-ci-build1:~/cxqdir# tree
.
├── low
│   └── 11.txt
├── merged
├── upper
│   └── 22.txt
└── work
    └── work
</code></pre>
<p>用下面的命令挂载overlayfs文件系统，该命令将low和upper合并成一个merged 名称的overlayfs文件系统。</p>
<p><code>mount -t overlay overlay -olowerdir=./low,upperdir=./upper,workdir=./work ./merged</code></p>
<p>再查看目录结构</p>
<pre><code>root@qa-control-pub-ci-build1:~/cxqdir# tree
.
├── low
│   └── 11.txt
├── merged
│   ├── 11.txt
│   └── 22.txt
├── upper
│   └── 22.txt
└── work
    └── work

5 directories, 4 files
</code></pre>
<p>可以看到merged中展示的文件是low和upper里面的文件集合。</p>
<p>3.同名覆盖的测试 原始内容如下</p>
<pre><code>root@qa-control-pub-ci-build1:~/cxqdir/merged# cat 11.txt 
1111111111111111111111
root@qa-control-pub-ci-build1:~/cxqdir/merged# cat 22.txt 
2222222
</code></pre>
<p>在merge目录中对11.txt内容进行修改，例如</p>
<pre><code>root@qa-control-pub-ci-build1:~/cxqdir/merged# vim 11.txt 
root@qa-control-pub-ci-build1:~/cxqdir/merged# cat 11.txt 
333333333
</code></pre>
<p>分别查看low和upper目录下文件，发现low下面的同名文件内的内容没有变，而upper里面多了一个同名文件。</p>
<pre><code>root@qa-control-pub-ci-build1:~/cxqdir/merged# cat ../low/11.txt
1111111111111111111111
root@qa-control-pub-ci-build1:~/cxqdir/merged# cat ../upper/11.txt
333333333
</code></pre>
<p>值得注意的是upper中新增的11.txt文件和merge中的文件node是一样的。</p>
<pre><code>root@qa-control-pub-ci-build1:~/cxqdir/merged# ls -i ../upper/11.txt
350031 ../upper/11.txt
root@qa-control-pub-ci-build1:~/cxqdir/merged# ls -i 11.txt
350031 11.txt
</code></pre>
<p>但是跟底层low内的同名文件node不一样</p>
<pre><code>root@qa-control-pub-ci-build1:~/cxqdir/merged# ls -i ../low/11.txt 
350033 ../low/11.txt
</code></pre>
<p>4.删除文件的测试</p>
<p>在merge中将11.txt删除。</p>
<pre><code>root@qa-control-pub-ci-build1:~/cxqdir/merged# rm 11.txt 
root@qa-control-pub-ci-build1:~/cxqdir/merged# ls -l 
total 4
-rw-r--r-- 1 root root 8 May  6 13:55 22.txt
</code></pre>
<p>查看low文件11.txt仍然是最一开始时的内容。</p>
<pre><code>root@qa-control-pub-ci-build1:~/cxqdir/merged# cat ../low/11.txt 
1111111111111111111111
</code></pre>
<p>查看upper目录中仍然有11.txt文件，但是变成一个大小为0，且没有任何人有权限的一个空文件。</p>
<pre><code>root@qa-control-pub-ci-build1:~/cxqdir/merged# ls -l ../upper/11.txt
c--------- 1 root root 0, 0 May  6 14:08 ../upper/11.txt
</code></pre>
<p>overlayfs用这种删除标记的方式标识文件被删除，（如果upper中没有该文件的话，则底层low中的同名文件又恢复出来显示了，因此需要有这个空文件来标识删除，并且覆盖底层的文件）</p>
<pre><code>root@qa-control-pub-ci-build1:~/cxqdir/merged# rm ../upper/11.txt    （不建议这么操作）
root@qa-control-pub-ci-build1:~/cxqdir/merged# ls
11.txt    22.txt
root@qa-control-pub-ci-build1:~/cxqdir/merged# cat 11.txt 
1111111111111111111111
</code></pre>
<h3>docker中overlayFS的应用</h3>
<p>如果想在docker中使用overlay模式，则需要在/etc/default/docker配置如下 DOCKER_OPTS=“-s=overlay ” 查看docker目录下的overlay文件夹。 里面放置着多个image分层的uuid文件夹： 例如</p>
<pre><code>root@qa-control-pub-ci-build1:/var/lib/docker/overlay/fe92ccc33d26116c6cf3d6e1fb5ccb18233ad7613e41d43176cb8214061cd598# tree
.....
├── spool │
├── mail -&gt; ../mail 
└── plymouth
└── tmp

1347 directories, 14849 files 
</code></pre>
<p>这个标识这一个分层里面的所有内容，如何把多个分层联系起来呢，就要找到/etc/default/docker/graph下的同名文件夹中的json文件，里面有关于本层以及它的parent的描述：</p>
<pre><code>3d6e1fb5ccb18233ad7613e41d43176cb8214061cd598# cat json |python -m json.tool
{
无关信息省略...
    "created": "2015-12-30T08:22:50.386102166Z", 
    "docker_version": "1.9.1", 
    "id": "fe92ccc33d26116c6cf3d6e1fb5ccb18233ad7613e41d43176cb8214061cd598", 
    "os": "linux", 
    "parent": "7d1b79980f8821729e0dea5f640f508db09fd111ff128bf333b3eb900b5f2610"
}
</code></pre>
<p>这样连起来上下多层就可以构成一个完整的镜像，同时每一层又可以独立使用。 一组多层镜像的组织示意图：</p>
<p><img src="https://cloudcomb-blog.nos-eastchina1.126.net/201608130941%2F2.PNG" alt="img" /></p>
