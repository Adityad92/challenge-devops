The `path/filepath` package in Go provides functions for manipulating filename paths in a way that is compatible with the target operating system's file paths. When applying the 80-20 principle, we focus on the most commonly used functions that handle the majority of path manipulation tasks.  
   
1. **Joining and Splitting Paths**:  
   - `filepath.Join(elem ...string) string`: Combines any number of path elements into a single path, adding a separator if necessary. It's the go-to function for building file paths in a cross-platform way.  
   - `filepath.Split(path string) (dir, file string)`: Splits a path into a directory and file component.  
   
2. **Cleaning Paths**:  
   - `filepath.Clean(path string) string`: Returns the shortest path equivalent to the given path by purely lexical processing. It removes redundant separators and resolves any "." or ".." elements.  
   
3. **Absolute and Relative Paths**:  
   - `filepath.Abs(path string) (string, error)`: Converts a relative path to an absolute path.  
   - `filepath.Rel(basepath, targpath string) (string, error)`: Returns a relative path that is lexically equivalent to `targpath` when joined to `basepath`.  
   
4. **Working with Directories**:  
   - `filepath.Dir(path string) string`: Returns all but the last element of the path, typically the path's directory.  
   - `filepath.Base(path string) string`: Returns the last element of the path.  
   
5. **File Extension Handling**:  
   - `filepath.Ext(path string) string`: Returns the file name extension used by the path.  
   
6. **Globbing**:  
   - `filepath.Glob(pattern string) ([]string, error)`: Returns the names of all files matching the specified pattern (wildcards are allowed).  
   
7. **Walking a Directory Tree**:  
   - `filepath.Walk(root string, walkFn filepath.WalkFunc) error`: Walks the file tree rooted at `root`, calling `walkFn` for each file or directory in the tree, including `root`.  
   
**Scenarios**:  
   
- **Constructing File Paths**: When you need to build file paths dynamically, such as when creating files in a directory or accessing nested resources, use `filepath.Join` to ensure the paths are constructed correctly for the OS.  
   
```go  
configDir := "/etc/myapp"  
configFile := "config.json"  
path := filepath.Join(configDir, configFile)  
fmt.Println(path) // Output: /etc/myapp/config.json on Unix-like OS  
```  
   
- **Cleaning and Normalizing Paths**: Use `filepath.Clean` when you have a path that may contain unnecessary elements like ".." or "//", and you want to normalize it.  
   
```go  
dirtyPath := "///some//path/.."  
cleanPath := filepath.Clean(dirtyPath)  
fmt.Println(cleanPath) // Output: /some  
```  
   
- **Finding Files**: If you need to find all files with a certain extension within a directory, use `filepath.Glob`.  
   
```go  
files, err := filepath.Glob("/path/to/directory/*.txt")  
if err != nil {  
    log.Fatal(err)  
}  
fmt.Println(files) // Output: list of .txt files in the specified directory  
```  
   
- **Walking Directories**: When you need to process all files in a directory and its subdirectories, use `filepath.Walk`.  
   
```go  
err := filepath.Walk("/path/to/directory", func(path string, info os.FileInfo, err error) error {  
    if err != nil {  
        return err  
    }  
    fmt.Println(path, info.Size())  
    return nil  
})  
if err != nil {  
    log.Fatal(err)  
}  
```  
   
- **Extracting File Information (Continued)**:  
  - `filepath.Dir`, `filepath.Base`, and `filepath.Ext` to get different parts of the file path.  
   
```go  
fullPath := "/path/to/file.txt"  
dir := filepath.Dir(fullPath)  
base := filepath.Base(fullPath)  
ext := filepath.Ext(fullPath)  
   
fmt.Println("Directory:", dir)  // Output: /path/to  
fmt.Println("File:", base)      // Output: file.txt  
fmt.Println("Extension:", ext)  // Output: .txt  
```  
   
- **Determining Relative Paths**: When you need to find the relative path between two file paths, for example, when generating URLs or reducing path length, use `filepath.Rel`.  
   
```go  
basePath := "/a"  
targetPath := "/a/b/c/d.txt"  
relPath, err := filepath.Rel(basePath, targetPath)  
if err != nil {  
    log.Fatal(err)  
}  
fmt.Println(relPath) // Output: b/c/d.txt  
```  
   
- **Handling Absolute Paths**: Use `filepath.Abs` to ensure you have an absolute path, which might be necessary when working with libraries that require absolute paths or for consistent path handling.  
   
```go  
relPath := "file.txt"  
absPath, err := filepath.Abs(relPath)  
if err != nil {  
    log.Fatal(err)  
}  
fmt.Println(absPath) // Output: absolute path to file.txt  
```  
   
- **Splitting Paths**: If you need to separate a file name from its directory path, use `filepath.Split`.  
   
```go  
fullPath := "/path/to/file.txt"  
dir, file := filepath.Split(fullPath)  
fmt.Println("Directory:", dir)  // Output: /path/to/  
fmt.Println("File:", file)      // Output: file.txt  
```  
   
These functions and scenarios represent the most common ways developers interact with file paths. By understanding and utilizing these aspects of the `path/filepath` package, you can handle the vast majority of file path operations in a cross-platform and reliable manner. Remember that file path manipulation is a common source of bugs, especially when dealing with different operating systems, so always prefer using the `filepath` package over string manipulation to ensure your code is robust and portable.