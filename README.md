# 汇编学习

> VS Code的汇编环境配置可真他妈难  
> 环境：  
> [MASM32<-点击即可下载](http://www.masm32.com/)  
> 环境变量:  
> > 如果有该条目，则在该条目的最前面添加，如果没有，则新建。  
> > include项中添加C:\masm32\include  
> > lib中添加C:\masm32\lib  
> > path中添加C:\masm32\bin

``` JavaScript
//launche.json
{
    // 使用 IntelliSense 了解相关属性。 
    // 悬停以查看现有属性的描述。
    // 欲了解更多信息，请访问: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "g++.exe build and debug active file",
            "type": "cppdbg",
            "request": "launch",
            "program": "${fileDirname}\\${fileBasenameNoExtension}.exe",
            "args": [
            ],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false,
            "MIMode": "gdb",
            "miDebuggerPath": "C:\\MinGW\\bin\\gdb.exe",
            "setupCommands": [
                {
                    "description": "为 gdb 启用整齐打印",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ],
            "preLaunchTask": "Masm Build"
        }
    ]
    //这条是MASM32的PowerShell命令行指令
    //ml /c /coff AddTwo.asm &&  link /subsystem:windows AddTwo.asm
}
```

``` JavaScript
//tasks.json
{
    "tasks": [
        {
            "type": "shell",
            "label": "Masm Build",
            "command": "ml.exe",
            "args": [
                "/c",
                "/coff",
                "${file}",
                "\r\n",
                "link",
                "/subsystem:windows",
                "${fileDirname}\\${fileBasenameNoExtension}.obj"
            ],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "presentation": {
                "reveal": "always"
            },
            "problemMatcher": "$msCompile"
        }
    ],
    "version": "2.0.0"
}
```
