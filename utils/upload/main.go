package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"
)

var timeStr = "06-01-02"

func main() {
	if len(os.Args) >= 3 {
		uploadFile, err := os.Stat(os.Args[2])
		if err != nil {
			fmt.Println(os.Args[2], " 文件不存在")
			return
		}
		if uploadFile.IsDir() {
			fmt.Println(os.Args[2], " 不能上传文件夹！")
			return
		}
		timeStr = time.Now().Format(timeStr)
		switch os.Args[1] {
		case "upload":
			fmt.Println(upload(os.Args[2]))
		case "test":
			test()
		case "loadfile":
			fmt.Println(download(true, os.Args[2]))
		case "loadfolder":
			fmt.Println(download(false, os.Args[2]))
		default:
			fmt.Println(os.Args[1], "未识别的命令")
		}
	} else {
		fmt.Println("缺少必要参数！")
		return
	}
}

// ## 任务：上传文件
// 1. 远程服务器下载到本地.bak
// 2. 本地上传原文件和.bak文件到远程
// 3. 本地删除.bak文件
// d:\app\APcode\topprod\tiptop\abg\4gl\abgi002.4gl
// /u1/topprod/tiptop/abg/4gl/abgi002.4gl
func upload(filePath string) string {
	remotePath, path, bakfileName, fileName := pathAnalysis(filePath)

	//1.远程查找备份到本地
	err := exec.Command(
		"scp",
		"tiptop@192.168.1.19:"+remotePath+bakfileName,
		path,
	).Run()
	if err != nil {
		// 不处理，失败可能是因为没有备份
	}
	//2.无->2.1 有->3
	_, err = os.Stat(path + bakfileName)
	if err != nil {
		// 本地文件不存在，需要备份bak文件
		//2.1下载远程到本地
		//1.备份远程到本地
		err = exec.Command("scp", "tiptop@192.168.1.19:"+remotePath+fileName, path+bakfileName).Run()
		if err == nil {
			//2.2上传备份到远程
			err = exec.Command("scp", path+bakfileName, "tiptop@192.168.1.19:"+remotePath).Run()
			if err != nil {
				return "2.2 本地上传原文件和.bak文件到远程失败！  "
			}
		}
	}
	//3 上传文件到远程
	err = exec.Command("scp", filePath, "tiptop@192.168.1.19:"+remotePath).Run()
	if err != nil {
		return "3. 本地上传原文件和.bak文件到远程失败！  "
	}
	//4. 本地删除.bak文件
	err = os.Remove(path + bakfileName)
	if err != nil {
		//return "4 本地删除.bak文件!失败  "
	}

	return fmt.Sprintf("%s、%s上传成功，目录为%s。", fileName, bakfileName, remotePath)
}
func test() {
	fmt.Println(exec.Command("scp", "tiptop@192.168.1.19:/u1/topprod/tiptop/axc/4gl/axcp500.4gl", "D:\\app\\APcode\\utils").Run())
}

// 路径分析
func pathAnalysis(filePath string) (remotePath, path, bakfileName, fileName string) {
	path, fileName = filepath.Split(filePath)
	bakfileName = fileName + ".darcy" + timeStr //备份文件名
	// 获取远程路径
	temp := strings.Split(path, "\\")
	temp = append([]string{"u1"}, temp[len(temp)-5:]...)
	for _, v := range temp {
		remotePath += "/"
		remotePath += v
	}
	return
}

// 同步本地文件
// 1.同步前git一下
// 2.同步文件
// 3.同步后git一下
// git由task直接实现
func download(file bool, filePath string) string {
	remotePath, path, _, fileName := pathAnalysis(filePath)
	path = strings.Replace(path, "4gl\\", "", -1)
	var err error
	if file {
		err = exec.Command(
			"scp",
			"-r",
			"tiptop@192.168.1.19:"+remotePath+fileName,
			filePath,
		).Run()
	} else {
		err = exec.Command(
			"scp",
			"-r",
			"tiptop@192.168.1.19:"+remotePath,
			path,
		).Run()
	}
	if err != nil {
		fmt.Println("下载失败!", err)
	}
	return "下载成功," + remotePath
}
