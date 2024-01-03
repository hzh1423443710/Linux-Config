# Git

工作区<=>工作目录<=>worktree

缓存区<=>暂存区<=>index

版本库: git commit

```bash
git add <[file]|[dir]>		添加工作区的文件或更改到暂存区
git commit -m [message]		将暂存区内容添加到版本库
```



## config

```bash
git config [--global] --list				global配置全局, 无global配置当前仓库
git config --global user.name <>			配置 全局用户名
git config --global user.email <>			配置 全局邮箱

git config --global format.pretty oneline	使log单行显示

git config <-e|--edit>							编辑当前仓库的配置文件
git config <-e|--edit> --global					针对所有仓库
```



## 仓库

```bash
git init									初始化仓库

git clone /path/to/repository				创建一个本地仓库的克隆版本
git clone username@host:/path/to/repository	  克隆远端服务器上的仓库
```



## log

查看历史提交记录

```bash
git log --oneline --graph --all
git show <commid>					   显示提交的详细信息
git blame [options] <filepath>			逐行显示文件每行内容是什么时候引入或修改的
```



## status

```bash
git status [-s|--short]
```



## ls-files

```bash
git ls-files			    列出 跟踪的文件
git ls-files --others		列出 未跟踪的文件
git ls-files --stage		列出 缓存区文件 的文件模式,对象信息
git ls-files --cached		只列出 缓存区文件
```



## rm mv

```bash
git rm <file>...	        将文件从 暂存区和本地  删除. 等价于 rm + git add .
git rm --cached		        只将文件从 暂存区 删除

git mv 					   移动或重命名, 相当于mv + git add .
```



## restore

```bash
git restore [--worktree] <file>	撤销 工作树 的更改, 即将文件恢复到暂存区的最近一次修改状态
git restore --staged <file> 撤销 暂存区 的更改, 但保留工作树中的更改
git restore --source=<commit> <file>  还原文件到指定提交的状态
```



## rebase

将当前分支上的提交应用到另一个分支上, 并合并这些提交

会使提交树变得很干净, 所有的提交都在一条线上

```bash
git rebase <target_branch>  将当前分支上的提交逐个应用到目标分支上
git rebase -i <target_branch> 交互式可选择排序

git rebase branch1 branch2	将 branch2 分支基于 branch1 分支进行重新排列合并
```

> git rebase branch1 branch2 等价于git switch branch2 + git rebase branch1



### cherry-pick

将指定提交 拷贝 到当前分支中, 不合并

```bash
git cherry-pick <commit> ...
```



## reset

版本回退, 提交历史被撤销(只影响本地仓库). **默认是 mixed 模式**

```bash
git reset [--mixed] <commit>	重置HEAD到指定提交,  暂存区回退, 工作树不回退
git reset --soft <commit>		重置HEAD到指定提交,  工作树不回退, 但保留commit的更改在暂存区
git reset --hard <commit>		重置HEAD到指定提交,  工作树和暂存区 都回退
```

> Example: git reset --mode HEAD^  HEAD指针移动到上一次提交
>
> - hard: 暂存区 和 工作树 都回到HEAD^, 即没有任何未提交的更改
>
> - soft: 工作树还是HEAD的, HEAD的commit的更改会保留
> - mixed: 暂存区回退到HEAD^, 即等待添加更改到暂存区. 工作树还是HEAD的



## revert

新建一个提交, 来撤销一个更改(逆向commit)

```bash
git revert <commit> 	
```

> A(add file1) -> B(add file2) -> C(add file3)
>
> 当前有file1, file2, file3, git revert A 相当于 删除file1



## branch

```bash
git branch <name>           在HEAD上创建新的分支(包含当前所在分支的所有提交历史和代码内容)
git branch                  列出 本地所有分支
git branch -r               列出 远程所有分支
git branch -a               列出所有本地和远程分支
git branch [branch-name]    创建一个新的分支

git branch <new-branch-name> commit  		在指定提交上创建一个分支
git branch -f <new-branch-name> commit		强制移动分支指针到一个新的提交(会丢弃了原来的提交历史)

git branch -d [branch-name] 删除一个已经合并到当前分支的分支
git branch -D [branch-name] 强制删除一个分支，即使该分支没有被合并
git branch -m [old-branch-name] [new-branch-name] 重命名一个分支
```



## checkout

```bash
git checkout <commit>			切换到某个提交(分离HEAD指针)
git checkout <branch>			切换分支
git checkout -b <branch>		 创建并切换分支

git checkout tags/<tag-name>	 切换到标签指向的提交状态

git checkout - 					快速切换到上一个分支
git checkout -- <file>			 恢复工作区到最近一次提交, 不修改暂存区
```

### 相对引用

```bash
git checkout HEAD^			切换到 上个提交(分离HEAD指针)
git checkout master^			切换到 上个提交(分离HEAD指针)
git checkout HEAD~				切换到 上个提交(分离HEAD指针)
git checkout ~<num>

git checkout HEAD~^2~			先HEAD~, 找到第2个父提交, 再HEAD~
```

> **分离头指针状态:**
>
> ​	不属于任何分支. 在该状态下的提交也不属于任何分支, 并且切换到其他分支时, 这个提交会被丢弃. 除非创建一个新的分支保留它 `git branch <new-branch-name> commit`



## switch

```bash
git switch <branch>			切换分支
git switch -c <branch>		创建并切换分支
git switch -				快速切换到上一个分支
```



## diff

比较文件不同

```bash
git diff [file|dir]					 	比较当前工作区与暂存区的差异
git diff --staged/cached [file|dir]	   	  比较暂存区和最新一次提交的差异
git diff <commit>						比较工作区与commidId的差异
git diff <commit> <commit>				 比较2次提交之间的差异
git diff --stat ...      			 	 显示摘要而非整个diff 
```



## fetch

```bash
git fetch					git fetch只更新远程分支 不修改本地分支
git fetch origin <src>:<dst>
git fetch origin :<branch>	 fetch 空 到本地, 会在本地创建一个新分支
```

> dst不存在会创建分支
>
> git fetch 没有参数: 下载所有的提交记录到各个远程分支



## pull

```bash
git pull					等价于 git fetch + git merge origin/master
git pull --rebase			 等价于 git fetch + git rebase origin/master
git pull origin <src>:<dst>
```

> dst 分支不存在会创建, 然后git fetch origin/src, git merge dst



## push

```bash
git push					将当前分支的本地提交推送到与之关联的远程分支
git push origin <src>:<dst>   将本地src位置 提交到 远程dst分支
git push origin :<branch>	  push 空到远程会删除branch分支
```

> dst不存在会创建
