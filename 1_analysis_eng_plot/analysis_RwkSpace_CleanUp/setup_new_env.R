##  `setup.R` 脚本（用于恢复 renv 环境）
  

# setup.R - 在新环境中恢复 renv 项目依赖
# --------------------------------------------
# 功能：
# - 安装 renv（如果尚未安装）
# - 激活 renv
# - 使用 renv::restore() 恢复依赖
# --------------------------------------------

# message(" 正在初始化 R 项目依赖恢复过程...")

# 1. 安装 renv（如未安装）
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}

# 2. 激活 renv（会自动连接 renv/activate.R）
renv::activate()

# 3. 检查 renv.lock 是否存在
# if (!file.exists("renv.lock")) {
#   stop("× 未找到 renv.lock 文件，无法恢复依赖环境。请确认你已经复制完整项目。")
# }

# 4. 恢复依赖
# message("正在根据 renv.lock 恢复依赖环境...")
renv::restore(prompt = FALSE)

# message("✓ 项目依赖恢复完成！你现在可以正常运行项目脚本 或 R Notebook。")




---
  
## 使用方式
  
# 1. 将此脚本放入项目根目录（与 `.Rproj` 和 `renv.lock` 同级）
# 2. 打开 RStudio，打开 `.Rproj` 文件
# 3. 在 Console 中运行：

# ```r
# source("setup.R")
# ```


---
  
## 成功执行后，你将得到：
  
# - 所有依赖包与原项目一致；
# - 项目可以无缝运行；
# - 环境完全隔离，不影响其他项目或全局包。
  



  