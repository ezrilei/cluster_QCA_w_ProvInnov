# set working directory ----
# set the folder where the RScript locates as working dir (you need Rstudio to do this)
setwd(
  dirname(rstudioapi::getSourceEditorContext()$path)
)

# load package ----
library(tidyverse)

## 设置  scientific penalty 选项以取消科学计数法表示 ----
options(scipen = 999)


## variables explained ----


# 区域创新能力效用值   Innovation
# R&D经费投入强度      RDinvest

# 政府引导基金投资     GovGuided
# 地区生产总值         RegionGDP

# 政府创新补贴         GovInnoSub
# 孵化基金支持         Incubation

# 众创空间服务         MakerSpace

# 政府创新采购         GovInnoProc # Government Procurement of Innovation

# R&D人员全时当量      RDperson

# 高新技术企业数量     numHighTech
# 技术市场成交额       TechMarket



## Y - 区域创新能力效用值 ----
df.Innovation <- readxl::read_excel(path = "./input/00_区域创新能力效用值.xlsx",
                                    sheet = 1,
                                    skip = 1 # 把年鉴的年份 这一行 skip 了
                                    )


# 宽格式（wide format） 转换为 长格式（long format）
df.Innovation <- df.Innovation %>%
  pivot_longer(
    cols = -`数据的年份`,  # 除"数据的年份"外，其余列转为长格式
    names_to = "year",     # 生成"year"列（数据的年份）
    values_to = "区域创新能力效用值"    # 生成"区域创新能力效用值"列
  ) %>%
  rename(region = `数据的年份`) %>%  # 重命名"数据的年份"为"region"
  mutate(year = as.integer(year))  # 确保年份列为整数格式


### year += 1  ←—— -----

# 这里2024年的报告，用2022年的数据计算，代表2024年的水平。
# 我们参照
# [1]荆玲玲,黄慧丽.时空双维下数字创新生态系统对区域创新能力的激发与影响研究——基于省域面板数据的动态QCA分析[J].科技进步与对策,2024,41(16):13-23.
# 其直接使用当年的报告，代表当年的创新水平，尽管计算创新水平的数据来自前面2年。

# 这里我们，承认报告的创新水平代表当年水平。
# 也就是说2024年报告，代表2024年区域创新水平。

# 同时，参考
# [1]王欣.TOE框架下高技术产业科技成果转化组态研究[J].科研管理,2024,45(06):164-173.DOI:10.19571/j.cnki.1000-2995.2024.06.017.
# 考虑 条件变量对结果变量的影响具有一定时滞性,
# 结果变量采用 2024 年数据,
# 条件变量采用 2023 年数据。

# 为了后续面板分析能够正常识别，我们把数据年份加一年（报告的年份减一年），
# 使得，2024年报告的创新水平，能够被后续与其他条件变量的2023年数据放在一起。

df.Innovation <- df.Innovation %>%
  mutate(year = year + 1)


## X1 - R&D经费投入强度 ----
df.RDinvest <- readxl::read_excel(path = "./input/01_研究与试验发展(RD)经费投入强度.xlsx",
                                  sheet = 1
)

df.RDinvest <- df.RDinvest %>%
  select(region, year, `研究与试验发展(R&D)经费投入强度（%）`) 





## X2 - 01 - 政府引导基金投资  <--- ----

df.GovGuided <- readxl::read_excel(path = "./input/02_01_分年度_分地区_出资人为国资的基金_目标规模（政府引导基金投资总金额）_累计.xlsx",
                                   sheet = 1
                                   )
# rename col
df.GovGuided <- df.GovGuided %>% 
  rename(region = "注册地区_省",
         year = "成立时间_年"
         )


## X2 - 02 - 地区生产总值 ----
# 在值将作为部分数值的分母，先读取。
df.RegionGDP <- readxl::read_excel(path = "./input/02_02_地区生产总值(2016-2023年）.xlsx",
                                   sheet = 1
)




## X3 - 政府创新补贴 ---- 
df.GovInnoSub <- readxl::read_excel(path = "./input/03_分年-分地区-上市公司获得政府创新补助总额.xlsx",
                                    sheet = 1
)

df.GovInnoSub <- df.GovInnoSub %>%
  rename(region = "prov_reg")



## X4 - 孵化基金支持  <--- ----
df.Incubation <- readxl::read_excel(path = "./input/04_分年份_分地区_孵化基金支持_孵化基金总额_2015-2023年.xlsx",
                                    sheet = 1,
                                    skip = 1 # 把年鉴的年份 这一行 skip 了
)

# 宽格式（wide format） 转换为 长格式（long format）
df.Incubation <- df.Incubation %>%
  pivot_longer(
    cols = -`数据的年份`,  # 除"数据的年份"外，其余列转为长格式
    names_to = "year",     # 生成"year"列（数据的年份）
    values_to = "孵化基金总额"    # 生成"孵化基金总额"列
  ) %>%
  rename(region = `数据的年份`) %>%  # 重命名"数据的年份"为"region"
  mutate(year = as.integer(year))  # 确保年份列为整数格式



## X5 - 众创空间服务 <--- ----
df.MakerSpace <- readxl::read_excel(path = "./input/05_分年份_分地区_众创空间服务_创业团队、初创企业当年获得投融资总额_2016-2023年.xlsx",
                                    sheet = 1,
                                    skip = 1 # 把年鉴的年份 这一行 skip 了
)

# 宽格式（wide format） 转换为 长格式（long format）
df.MakerSpace <- df.MakerSpace %>%
  pivot_longer(
    cols = -`数据的年份`,  # 除"数据的年份"外，其余列转为长格式
    names_to = "year",     # 生成"year"列（数据的年份）
    values_to = "创业团队、初创企业当年获得投融资总额"    # 生成"创业团队、初创企业当年获得投融资总额"列
  ) %>%
  rename(region = `数据的年份`) %>%  # 重命名"数据的年份"为"region"
  mutate(year = as.integer(year))  # 确保年份列为整数格式



## X6 - 政府创新采购 ----

df.GovInnoProc <- readxl::read_excel(path = "./input/06_中国各省份政府单位创新采购数据2015-2023.xlsx",
                                     sheet = 1
)


df.GovInnoProc <- df.GovInnoProc %>%
  rename(year = "采购年度",
         region = "所属省份",
         政府单位创新采购数量对数= "对数化处理"
  )




## X7 - R&D人员全时当量 ----
df.RDperson <- readxl::read_excel(path = "./input/07_研究与试验发展（RD)人员全时当量.xlsx",
                                  sheet = 1
)

df.RDperson <- df.RDperson %>%
  select(region, year, `研究与试验发展(R&D)人员全时当量（人年）`) 




## X8 - 高新技术企业数量 ----
df.numHighTech <- readxl::read_excel(path = "./input/08_分地区-分年份-高新技术企业-入统企业数量.xlsx",
                                     sheet = 1,
                                     skip = 1 # 把年鉴的年份 这一行 skip 了
)

# 宽格式（wide format） 转换为 长格式（long format）
df.numHighTech <- df.numHighTech %>%
  pivot_longer(
    cols = -`数据的年份`,  # 除"数据的年份"外，其余列转为长格式
    names_to = "year",     # 生成"year"列（数据的年份）
    values_to = "高新技术企业数量"    # 生成"高新技术企业数量"列
  ) %>%
  rename(region = `数据的年份`) %>%  # 重命名"数据的年份"为"region"
  mutate(year = as.integer(year))  # 确保年份列为整数格式




## X9 - 01 - 技术市场交易额 <--- ----
df.TechMarket <- readxl::read_excel(path = "./input/09_01_分地区技术市场成交额（万元）.xlsx",
                                    sheet = 1
                                    )

# 删去 地区名称中的空格 "北  京" → "北京"
df.TechMarket <- df.TechMarket %>% mutate(地区 = 地区 %>% str_remove_all(pattern = "\\s+"))



# 宽格式（wide format） 转换为 长格式（long format）
df.TechMarket <- df.TechMarket %>%
  pivot_longer(
    cols = -`地区`,  # 除"地区"外列，其余列转为长格式
    names_to = "year",     # 生成"year"列（数据的年份）
    values_to = "技术市场成交额"    # 生成"技术市场成交额"列
  ) %>%
  rename(region = `地区`) %>%  # 重命名"地区"为"region"
  mutate(year = as.integer(year))  # 确保年份列为整数格式


# 使用线性插值（Linear Interpolation）填补西藏2016缺失值

df.TechMarket <- df.TechMarket %>%
  group_by(region) %>%
  mutate(技术市场成交额 = zoo::na.approx(技术市场成交额, rule = 2)) %>%  # 允许外推填补缺失值 extrapolate
  ungroup()




# Merge Data ----

# 将所有数据框存入一个列表

df_list <- list(df.Innovation, df.RegionGDP, 
                df.RDinvest, df.GovGuided, df.GovInnoSub,
                df.Incubation, df.MakerSpace, df.GovInnoProc,
                df.RDperson, df.numHighTech, df.TechMarket
                )


# 使用 reduce() 和 full_join() 进行合并
df_merged <- reduce(df_list, full_join, by = c("region", "year"))


# 除以GDP ----

# 参考
# 政府引导基金投资密度的做法
# 除以地区生产总值（亿元）

df_wk <- df_merged %>%
  mutate(政府引导基金投资密度 = `累计目标规模(人民币/百万)` / `地区生产总值（亿元）`) %>% 
  mutate(知识产权保护强度 = `技术市场成交额` / `地区生产总值（亿元）`) %>% 
  mutate(case = paste(region, year, sep = "_")) # 加一列ID 用于后续分析
  

# 重新排一下顺序
# 用不上的
# - 累计目标规模(人民币/百万)
# - 创业团队、初创企业当年获得投融资总额
# - 地区生产总值（亿元）
# 就不select进去


df_wk <- df_wk %>%
  select(case, year, region,
         区域创新能力效用值,
         `研究与试验发展(R&D)经费投入强度（%）`,
         政府引导基金投资密度,
         政府创新补助总额,
         孵化基金总额,
         `创业团队、初创企业当年获得投融资总额`,
         政府单位创新采购数量对数,
         `研究与试验发展(R&D)人员全时当量（人年）`,
         高新技术企业数量,
         知识产权保护强度
  )



# 用于后续分析的df_input
# 1. 变量名称写简单一些
# 2. 字母要大写，因为后面用到的setMethod包，有要求

df_input <- df_wk %>%
  rename(
    CASE = "case",
    YEAR = "year",
    ID = "region",
    Y = "区域创新能力效用值",
    X1 = "研究与试验发展(R&D)经费投入强度（%）",
    X2 = "政府引导基金投资密度",
    X3 = "政府创新补助总额",
    X4 = "孵化基金总额",
    X5 = "创业团队、初创企业当年获得投融资总额",
    X6 = "政府单位创新采购数量对数",
    X7 = "研究与试验发展(R&D)人员全时当量（人年）",
    X8 = "高新技术企业数量",
    X9 = "知识产权保护强度"
  )


df_input <- df_input %>%
  filter(YEAR >= 2016 & YEAR <= 2023)  # 筛选 2016-2022 年的数据。


# write result ----
writexl::write_xlsx(x = df_input,
                    path = "./output/MOI_GovInnov_2016_2023_DataSet.xlsx"
                    )




