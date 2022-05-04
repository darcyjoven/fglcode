package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	if len(os.Args) >= 2 {
		filepath.Walk(os.Args[1], delet)
	} else {
		fmt.Println("请录入必要参数！")
	}
}
func delet(path string, info os.FileInfo, err error) error {
	if info.IsDir() {
		return nil
	}
	if strings.Count(path, "4gl") > 1 {
		//有2个4gl
		if strings.LastIndex(path, ".4gl") == len(path)-4 {
			// 且最后是.4gl
			return nil
		}
	}
	if strings.Count(path, "4fd") > 1 {
		//有2个4fd
		if strings.LastIndex(path, ".4fd") == len(path)-4 {
			// 且最后是.4fd
			return nil
		}
	}
	if strings.Count(path, "per") > 1 {
		//2个per
		if strings.LastIndex(path, ".per") == len(path)-4 {
			// 且最后是.per
			return nil
		}
	}
	os.Remove(path)
	// fmt.Println("delete ", path)

	return nil
}
