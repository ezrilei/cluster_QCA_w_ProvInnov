# setup.R - 项目初始化脚本
# 1. 初始化 renv 包管理环境（如果尚未初始化）
# 2. 安装并加载常用包
# 3. 快照当前依赖到 renv.lock

# 检查并安装 renv
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}

# 初始化 renv（仅当未初始化时）
if (!file.exists("renv.lock")) {
  renv::init(bare = TRUE)  # 用 bare = TRUE 避免自动安装所有包
} else {
  message("renv 已初始化，跳过 init()")
}

# renv: Project Environments for R
# 
# Welcome to renv! It looks like this is your first time using renv.
# This is a one-time message, briefly describing some of renv's functionality.
# 
# renv will write to files within the active project folder, including:
# 
#   - A folder 'renv' in the project directory, and
#   - A lockfile called 'renv.lock' in the project directory.
# 
# In particular, projects using renv will normally use a private, per-project
# R library, in which new packages will be installed. This project library is
# isolated from other R libraries on your system.
# 
# In addition, renv will update files within your project directory, including:
# 
#   - .gitignore
#   - .Rbuildignore
#   - .Rprofile
# 
# Finally, renv maintains a local cache of data on the filesystem, located at:
# 
#   - "~/Library/Caches/org.R-project.R/R/renv"
# 
# This path can be customized: please see the documentation in `?renv::paths`.
# 
# Please read the introduction vignette with `vignette("renv")` for more information.
# You can browse the package documentation online at https://rstudio.github.io/renv/.

# Do you want to proceed? [y/N]: y
# 
# - "~/Library/Caches/org.R-project.R/R/renv" has been created.
# 
# Restarting R session...
# 
# - Project '~/ezridb/forR/20250120_explore_QCA/1_analysis/analysis_RwkSpace_CleanUp' loaded. [renv 1.1.4]
# - The project is out-of-sync -- use `renv::status()` for details.

# install.packages('devtools')
# devtools::install_version("admisc", version = "0.36")



# 快照当前项目依赖
renv::snapshot(prompt = FALSE)

message("✅ 项目初始化完成！")


# 还原项目包环境
# renv::restore()

