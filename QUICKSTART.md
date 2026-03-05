# 生物医学翻译 Agent - 快速开始指南

## 📦 安装说明

### 前置要求

- Trae IDE 已安装并配置
- macOS 或 Linux 操作系统
- Bash shell (版本 4.0+)
- 标准 Unix 工具：grep, wc, stat, du

### 安装步骤

#### 方式 1: 自动安装 (推荐)

如果您已配置 skill-creator skill：

```bash
# 在 Trae IDE 中调用 skill-creator
# 输入：安装 bio-med-translator skill
```

#### 方式 2: 手动安装

1. **确认技能目录**
   ```bash
   # 技能应位于以下位置
   ~/.trae/skills/bio-med-translator/
   ```

2. **验证文件结构**
   ```bash
   cd ~/.trae/skills/bio-med-translator/
   tree -L 2
   ```
   
   应看到以下结构：
   ```
   bio-med-translator/
   ├── SKILL.md              # 技能主文件
   ├── README.md             # 完整文档
   ├── QUICKSTART.md         # 本文件
   ├── terminology/          # 术语库目录
   │   ├── core-terms.md
   │   ├── antibody-drugs.md
   │   ├── genomics.md
   │   ├── oligonucleotide.md
   │   └── clinical-medicine.md
   └── scripts/              # 工具脚本
       ├── search-terminology.sh
       └── manage-terminology.sh
   ```

3. **设置脚本执行权限**
   ```bash
   chmod +x scripts/*.sh
   ```

4. **验证安装**
   ```bash
   # 测试术语库统计
   ./scripts/manage-terminology.sh stats
   
   # 测试术语搜索
   ./scripts/search-terminology.sh antibody -n
   ```

## 🚀 快速使用

### 在 Trae IDE 中使用

#### 1. 基本翻译

直接在对话中调用技能：

```
用户：请翻译"The antisense oligonucleotide induces exon 51 skipping"

bio-med-translator:
【领域识别】小核酸制药
【翻译结果】"该反义寡核苷酸诱导 51 号外显子跳跃"
【术语对照】
- Antisense oligonucleotide | 反义寡核苷酸
- Exon skipping | 外显子跳跃
```

#### 2. 文档翻译

```
用户：请翻译这份摘要 [粘贴文本]

bio-med-translator 将：
1. 自动识别文档类型和领域
2. 加载对应术语库
3. 执行五阶段翻译流程
4. 提供完整译文和术语对照表
```

#### 3. 术语查询

```
用户：GalNAc conjugate 是什么意思？

bio-med-translator:
【术语检索】
英文：GalNAc conjugate
中文：GalNAc 偶联物
领域：小核酸制药 - 递送系统
说明：靶向肝细胞的递送技术...
```

### 命令行工具使用

#### 搜索术语

```bash
# 进入脚本目录
cd ~/.trae/skills/bio-med-translator/scripts

# 搜索术语
./search-terminology.sh antibody           # 在核心库搜索
./search-terminology.sh "gene expression" -a  # 在所有库搜索
./search-terminology.sh CRISPR -g -i       # 在基因组学库搜索 (忽略大小写)
./search-terminology.sh siRNA -o --exact   # 在小核酸库精确匹配
./search-terminology.sh -s                 # 显示统计信息
```

#### 管理术语库

```bash
# 显示统计信息
./manage-terminology.sh stats

# 验证术语库格式
./manage-terminology.sh validate

# 备份术语库
./manage-terminology.sh backup

# 导出为 CSV
./manage-terminology.sh export -o terms.csv

# 清理重复项
./manage-terminology.sh clean core-terms.md
```

## 📊 术语库概览

| 术语库 | 术语数 | 适用场景 |
|--------|--------|---------|
| core-terms | 2020+ | 通用生物医学 |
| antibody-drugs | 121+ | 抗体药、免疫治疗 |
| genomics | 380+ | 基因组学、测序 |
| oligonucleotide | 910+ | 小核酸药物 |
| clinical-medicine | 1111+ | 临床试验、诊疗 |
| **总计** | **4542+** | **全领域覆盖** |

## 🎯 常见使用场景

### 场景 1: 翻译研究论文

```
用户：我需要翻译这篇关于 siRNA 递送系统的论文摘要

处理流程：
1. 识别为研究论文类型
2. 识别为小核酸制药 + 递送系统领域
3. 加载 core-terms + oligonucleotide 术语库
4. 执行五阶段翻译
5. 输出译文 + 术语对照表 + 翻译说明
```

### 场景 2: 翻译临床试验方案

```
用户：请翻译这个临床试验方案的入选标准部分

处理流程：
1. 识别为临床试验文档
2. 识别为临床医学领域
3. 加载 core-terms + clinical-medicine 术语库
4. 遵循 GCP 规范翻译
5. 确保入选标准清晰明确
```

### 场景 3: 统一术语使用

```
用户：确保全文中"antibody"的翻译一致

处理流程：
1. 提取全文所有"antibody"相关术语
2. 对照术语库确认标准译法
3. 检查全文一致性
4. 标注不一致之处
5. 提供统一建议
```

## 🔧 故障排查

### 问题 1: 脚本无法执行

**症状**: `Permission denied`

**解决方案**:
```bash
chmod +x scripts/*.sh
```

### 问题 2: 术语库文件找不到

**症状**: `文件不存在` 错误

**解决方案**:
```bash
# 检查文件结构
ls -la terminology/

# 如果文件缺失，需要重新安装技能
```

### 问题 3: 搜索结果为空

**症状**: 搜索术语无匹配

**解决方案**:
```bash
# 尝试忽略大小写
./search-terminology.sh crispr -i

# 尝试在所有库中搜索
./search-terminology.sh crispr -a

# 检查术语是否已收录
grep -i "crispr" terminology/*.md
```

### 问题 4: 技能未响应

**症状**: 在 Trae 中调用技能无响应

**解决方案**:
1. 确认 SKILL.md 文件存在且格式正确
2. 重启 Trae IDE
3. 检查技能描述是否符合调用条件

## 📚 详细文档

- **完整使用指南**: [README.md](README.md)
- **技能说明**: [SKILL.md](SKILL.md)
- **术语库管理**: 运行 `./scripts/manage-terminology.sh help`
- **术语搜索**: 运行 `./scripts/search-terminology.sh --help`

## 🆘 获取帮助

### 命令行帮助

```bash
# 搜索工具帮助
./scripts/search-terminology.sh --help

# 管理工具帮助
./scripts/manage-terminology.sh help
```

### 在线资源

- MeSH 医学主题词表：https://meshb.nlm.nih.gov/
- 中国医学名词审定委员会：http://www.cnmst.org.cn/

### 反馈和支持

如遇到问题或有改进建议：
1. 检查 README.md 文档
2. 查看 SKILL.md 中的使用说明
3. 在 Trae 社区提问

## 📝 更新日志

### v3.0 (2026-03-05)
- ✅ 升级为完整翻译 Agent
- ✅ 实现五阶段翻译工作流
- ✅ 新增质量控制机制
- ✅ 支持 9 种文档类型
- ✅ 术语库扩展至 4542+ 条

### v2.0 (2026-03-05)
- 模块化术语库架构
- 异步加载机制

### v1.0 (原始版本)
- 初始术语库建立

---

**最后更新**: 2026-03-05  
**版本**: v3.0  
**维护状态**: 活跃维护中

## 🎓 学习资源

### 新手入门
1. 阅读本快速开始指南
2. 尝试基本翻译功能
3. 学习使用术语搜索工具

### 进阶使用
1. 阅读完整 README.md 文档
2. 了解五阶段翻译工作流
3. 掌握术语库管理工具

### 专家技巧
1. 自定义术语库
2. 批量处理文档
3. 集成到工作流中

---

**祝您使用愉快！** 🎉
