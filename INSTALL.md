# 生物医学翻译 Agent - 安装和配置指南

## 📦 完整文件清单

### 核心文件

| 文件 | 大小 | 说明 | 必需性 |
|------|------|------|--------|
| `SKILL.md` | 16.5KB | 技能主文件，包含完整的 Agent 定义和工作流 | ✅ 必需 |
| `README.md` | 13KB | 完整使用指南，包含所有功能和示例 | ✅ 必需 |
| `QUICKSTART.md` | 5KB | 快速开始指南，适合新手用户 | ⭕ 推荐 |
| `check-installation.sh` | 5KB | 安装检查脚本，验证安装完整性 | ⭕ 推荐 |

### 术语库文件 (terminology/)

| 文件 | 术语数 | 大小 | 领域 |
|------|--------|------|------|
| `core-terms.md` | 2020+ | 41KB | 核心基础术语 (A-Z) |
| `antibody-drugs.md` | 121+ | 5.7KB | 抗体药物与生物制剂 |
| `genomics.md` | 380+ | 16KB | 基因组学与生物信息学 |
| `oligonucleotide.md` | 910+ | 35KB | 小核酸制药 |
| `clinical-medicine.md` | 1111+ | 43KB | 临床医学与疾病 |
| **总计** | **4542+** | **140.7KB** | **全领域覆盖** |

### 工具脚本 (scripts/)

| 脚本 | 功能 | 必需性 |
|------|------|--------|
| `search-terminology.sh` | 术语搜索工具，支持多库搜索和高级选项 | ✅ 必需 |
| `manage-terminology.sh` | 术语库管理工具，统计/验证/备份/导出 | ✅ 必需 |

---

## 🔧 安装步骤

### 步骤 1: 确认安装位置

技能应安装在以下位置：

```bash
~/.trae/skills/bio-med-translator/
```

或

```bash
/Users/你的用户名/.trae/skills/bio-med-translator/
```

### 步骤 2: 验证文件结构

运行安装检查脚本：

```bash
cd ~/.trae/skills/bio-med-translator/
./check-installation.sh
```

**期望输出**：
```
✓ SKILL.md 存在
✓ SKILL.md 大小正常 (16509 字节)
✓ README.md 存在
✓ QUICKSTART.md 存在
✓ terminology 目录存在
✓ core-terms.md 存在 (2020 条术语)
✓ antibody-drugs.md 存在 (121 条术语)
✓ genomics.md 存在 (380 条术语)
✓ oligonucleotide.md 存在 (910 条术语)
✓ clinical-medicine.md 存在 (1111 条术语)
✓ scripts 目录存在
✓ search-terminology.sh 存在
✓ search-terminology.sh 可执行
✓ manage-terminology.sh 存在
✓ manage-terminology.sh 可执行
✓ 术语搜索功能正常
✓ 术语库统计功能正常
✓ 术语库验证功能正常

所有检查通过！技能已正确安装。
```

### 步骤 3: 设置执行权限 (如果需要)

如果脚本缺少执行权限：

```bash
chmod +x scripts/*.sh
chmod +x check-installation.sh
```

### 步骤 4: 验证安装

```bash
# 测试术语搜索
./scripts/search-terminology.sh antibody -n

# 测试术语库统计
./scripts/manage-terminology.sh stats
```

---

## 🚀 在 Trae IDE 中使用

### 基本调用

在 Trae IDE 的对话中，当您需要翻译生物医学相关内容时，技能会自动调用：

```
用户：请翻译"The siRNA was chemically modified with 2'-O-methyl groups"

bio-med-translator:
【领域识别】小核酸制药
【翻译结果】"该 siRNA 经过 2'-O-甲基化学修饰"
【术语对照】
- siRNA | 小干扰 RNA
- Chemically modified | 化学修饰
- 2'-O-methyl | 2'-O-甲基
```

### 文档翻译

```
用户：请翻译这份临床研究报告的摘要 [粘贴文本]

Agent 将：
1. 自动识别文档类型 (临床研究报告)
2. 加载对应术语库 (core + clinical-medicine)
3. 执行五阶段翻译流程
4. 提供完整译文 + 术语对照表 + 翻译说明
```

### 术语查询

```
用户：GalNAc conjugate 是什么意思？

Agent 将提供：
- 术语定义
- 中文译法
- 所属领域
- 相关术语
```

---

## 🛠️ 命令行工具使用

### 搜索术语

```bash
# 进入脚本目录
cd ~/.trae/skills/bio-med-translator/scripts

# 基本搜索
./search-terminology.sh antibody

# 在所有库中搜索
./search-terminology.sh "gene expression" -a

# 在特定库搜索
./search-terminology.sh CRISPR -g          # 基因组学库
./search-terminology.sh siRNA -o           # 小核酸库
./search-terminology.sh "monoclonal" -A    # 抗体库
./search-terminology.sh diagnosis -C       # 临床库

# 高级选项
./search-terminology.sh crispr -i          # 忽略大小写
./search-terminology.sh "exon 51" --exact  # 精确匹配
./search-terminology.sh antibody -n        # 只显示数量
```

### 管理术语库

```bash
# 显示统计信息
./manage-terminology.sh stats

# 验证术语库格式
./manage-terminology.sh validate

# 备份所有术语库
./manage-terminology.sh backup

# 导出为 CSV
./manage-terminology.sh export -o terms.csv

# 清理重复项
./manage-terminology.sh clean core-terms.md

# 显示帮助
./manage-terminology.sh help
```

---

## 📋 故障排查

### 问题 1: 技能未响应

**症状**: 在 Trae 中调用技能无响应

**解决方案**:
1. 确认 SKILL.md 文件存在
2. 检查 SKILL.md 的 frontmatter 格式是否正确
3. 重启 Trae IDE
4. 运行 `./check-installation.sh` 验证安装

### 问题 2: 脚本无法执行

**症状**: `Permission denied` 错误

**解决方案**:
```bash
chmod +x scripts/*.sh
chmod +x check-installation.sh
```

### 问题 3: 术语库文件找不到

**症状**: `文件不存在` 错误

**解决方案**:
1. 运行 `./check-installation.sh` 检查缺失的文件
2. 确认文件路径正确
3. 重新安装缺失的文件

### 问题 4: 搜索结果为空

**症状**: 搜索术语无匹配

**解决方案**:
```bash
# 尝试忽略大小写
./search-terminology.sh crispr -i

# 尝试在所有库中搜索
./search-terminology.sh crispr -a

# 直接 grep 搜索
grep -i "crispr" terminology/*.md
```

### 问题 5: 统计信息显示 0 条术语

**症状**: 术语计数为 0

**解决方案**:
1. 检查术语格式是否为 `- English | Chinese`
2. 验证术语库文件编码为 UTF-8
3. 运行 `./manage-terminology.sh validate` 检查格式

---

## 📚 文档资源

### 快速参考

| 文档 | 用途 | 适合人群 |
|------|------|---------|
| [QUICKSTART.md](QUICKSTART.md) | 快速开始，基本使用 | 新手用户 |
| [README.md](README.md) | 完整功能说明 | 所有用户 |
| [SKILL.md](SKILL.md) | Agent 定义和工作流 | 开发者/高级用户 |
| 本文档 | 安装和配置 | 所有用户 |

### 在线资源

- **MeSH 医学主题词表**: https://meshb.nlm.nih.gov/
- **ICD-10/11**: https://icd.who.int/
- **HGNC 基因命名委员会**: https://www.genenames.org/
- **UniProt**: https://www.uniprot.org/
- **中国医学名词审定委员会**: http://www.cnmst.org.cn/
- **中国药典**: https://www.chp.org.cn/

---

## 🔄 更新和维护

### 检查更新

定期运行安装检查脚本：

```bash
./check-installation.sh
```

### 更新术语库

```bash
# 备份现有术语库
./manage-terminology.sh backup

# 验证更新后的术语库
./manage-terminology.sh validate

# 查看统计信息
./manage-terminology.sh stats
```

### 版本历史

| 版本 | 日期 | 主要更新 |
|------|------|---------|
| v3.0 | 2026-03-05 | Agent 升级版，五阶段工作流 |
| v2.0 | 2026-03-05 | 模块化架构，异步加载 |
| v1.0 | - | 初始版本 |

---

## 📞 获取帮助

### 命令行帮助

```bash
# 搜索工具帮助
./scripts/search-terminology.sh --help

# 管理工具帮助
./scripts/manage-terminology.sh help
```

### 文档帮助

1. 查看 [QUICKSTART.md](QUICKSTART.md) 获取快速开始指南
2. 查看 [README.md](README.md) 获取完整功能说明
3. 查看 [SKILL.md](SKILL.md) 了解 Agent 工作原理

### 技术支持

如遇到文档未涵盖的问题：
1. 运行 `./check-installation.sh` 诊断问题
2. 查看错误日志和输出信息
3. 在 Trae 社区寻求支持

---

## ✅ 安装检查清单

在安装完成后，请确认以下项目：

- [ ] SKILL.md 文件存在且大小正常 (>10KB)
- [ ] README.md 文件存在
- [ ] QUICKSTART.md 文件存在
- [ ] terminology 目录存在
- [ ] 所有 5 个术语库文件存在
- [ ] scripts 目录存在
- [ ] 2 个脚本文件存在且有执行权限
- [ ] 运行 `./check-installation.sh` 全部通过
- [ ] 术语搜索功能正常
- [ ] 术语库统计功能正常
- [ ] 术语库验证功能正常

---

**安装完成日期**: 2026-03-05  
**最后更新**: 2026-03-05  
**版本**: v3.0  
**维护状态**: 活跃维护中

祝您使用愉快！🎉
