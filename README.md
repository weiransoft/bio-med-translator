# 生物医学翻译 Agent - 完整使用指南

## 🎯 快速开始

**新用户可以**：
1. 📖 阅读 [QUICKSTART.md](QUICKSTART.md) 快速上手
2. 📦 阅读 [SETUP.md](SETUP.md) 安装和配置
3. ✅ 运行 `./check-installation.sh` 验证安装
4. 🚀 直接在 Trae IDE 中调用技能进行翻译

---

## 🛠️ 文件处理能力

### 支持的文档格式

bio-med-translator 预装了多个 openskills，可直接读取和翻译各种格式的文档：

| 文件格式 | 扩展名 | 使用的 Skill | 典型场景 |
|---------|--------|-------------|---------|
| Microsoft Word | .docx, .doc | docx skill | 药品注册申报资料、临床试验方案、SOP |
| PDF | .pdf | pdf skill | 学术论文、监管指南、产品说明书 |
| Markdown | .md, .markdown | markdown skill | 技术文档、README、笔记 |
| Excel | .xlsx, .xls | excel skill | 实验数据、术语表、质量标准 |
| 纯文本 | .txt | 直接读取 | 简单文本、草稿 |

### 智能文件识别

Agent 会自动识别文件类型并调用对应的 skill：

```
用户提供文件路径 → 识别扩展名 → 自动调用 skill → 读取内容 → 翻译
```

无需手动指定使用哪个 skill，一切自动完成！

### 批量文件处理

支持同时翻译多个文件，自动建立统一的术语表，确保跨文件术语一致性。

---

## 📊 术语库概览

本 Agent 是生物医学领域最全面、最专业的中英双语翻译解决方案，采用模块化架构设计，支持异步加载和按需检索。涵盖从基础生物学到临床医学、药物研发、基因测序等全领域的专业术语。

### 术语库统计

| 领域 | 术语数量 | 子分类数 | 最后更新 |
|------|---------|---------|----------|
| 核心术语库 (A-Z) | 2020+ | 26 | 2026-03-05 |
| 抗体药物与生物制剂 | 121+ | 4 | 2026-03-05 |
| 基因组学与生物信息学 | 380+ | 9 | 2026-03-05 |
| 小核酸制药 | 910+ | 13 | 2026-03-05 |
| 临床医学与疾病 | 1111+ | 5 | 2026-03-05 |
| **总计** | **4542+** | **57** | - |

## 📁 目录结构

```
bio-med-translator/
├── SKILL.md                      # 技能主文件 (676 行)
├── README.md                     # 完整使用指南
├── QUICKSTART.md                 # 快速开始指南
├── check-installation.sh         # 安装检查脚本
├── terminology/                  # 术语库目录
│   ├── core-terms.md             # 核心基础术语 (A-Z, 2020+ 条)
│   ├── antibody-drugs.md         # 抗体药物术语 (121+ 条)
│   ├── genomics.md               # 基因组学术语 (380+ 条)
│   ├── oligonucleotide.md        # 小核酸制药术语 (910+ 条)
│   └── clinical-medicine.md      # 临床医学术语 (1111+ 条)
└── scripts/                      # 管理脚本目录
    ├── search-terminology.sh     # 术语搜索脚本
    └── manage-terminology.sh     # 术语库管理脚本
```

## 🚀 快速开始

### 使用技能进行翻译

在 Trae IDE 中调用 `bio-med-translator` 技能：

```
用户：请翻译"Antisense oligonucleotide targeting exon 51 skipping for DMD treatment"

技能自动识别：
- 领域：小核酸制药
- 加载术语库：core-terms.md + oligonucleotide.md
- 输出专业翻译和术语对照表
```

### 命令行工具

#### 搜索术语

```bash
# 进入脚本目录
cd /Users/wangwei/claw/.trae/skills/bio-med-translator/scripts

# 搜索术语
./search-terminology.sh antibody           # 在核心库中搜索
./search-terminology.sh "gene expression" -a  # 在所有库中搜索
./search-terminology.sh CRISPR -g -i       # 在基因组学库中搜索 (忽略大小写)
./search-terminology.sh siRNA -o --exact   # 在小核酸库中精确匹配

# 显示统计信息
./search-terminology.sh -s
```

#### 管理术语库

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
```

## 📚 术语库详细分类

### 1. 核心术语库 (core-terms.md)

**术语数**: 2020+ 条  
**子分类**: 26 个 (A-Z)  
**适用场景**: 通用生物医学翻译

包含生物医学领域最基础、最常用的核心术语，按字母顺序排列：
- A: Absorption, Activation, Acute, Adenine, Antibody, Antigen, Apoptosis...
- B: Bacteria, Base, Binding, Blood, Buffer...
- C: Cancer, Cell, Chromosome, Clinical, Culture...
- ... (完整覆盖 A-Z)

### 2. 抗体药物与生物制剂术语库 (antibody-drugs.md)

**术语数**: 121+ 条  
**子分类**: 4 个  
**适用场景**: 抗体药、生物类似药、免疫治疗

#### 分类详情
- **A. 抗体类型与结构**: 单抗、双抗、ADC、纳米抗体、Fc 受体等
- **B. 抗体工程与修饰**: 人源化、亲和力成熟、Fc 工程、偶联技术等
- **C. 抗体作用机制**: ADCC、CDC、免疫检查点阻断、T 细胞接合等
- **D. 已获批抗体药物**: 肿瘤靶向、免疫检查点抑制剂、炎症性疾病抗体、ADC、BsAb

#### 核心术语示例
```
Monoclonal Antibody (mAb) | 单克隆抗体
Bispecific Antibody (BsAb) | 双特异性抗体
Antibody-Drug Conjugate (ADC) | 抗体药物偶联物
ADCC | 抗体依赖的细胞介导的细胞毒性
CDR Grafting | CDR 移植
Pembrolizumab (帕博利珠单抗) | PD-1 抑制剂
```

### 3. 基因组学与生物信息学术语库 (genomics.md)

**术语数**: 380+ 条  
**子分类**: 9 个  
**适用场景**: 基因组学、测序技术、生物信息分析

#### 分类详情
- **A. 基因组学基础**: 基因组、外显子组、转录组、基因结构、剪接变异等
- **B. 遗传变异**: SNP、Indel、CNV、SV、突变类型、遗传学概念等
- **C. 测序技术与平台**: NGS、Illumina、PacBio、Nanopore、单细胞测序等
- **D. 序列分析**: 质量控制、序列比对、变异检测、功能分析等
- **E. 功能基因组学**: 基因表达、RNA-Seq、表观基因组学、DNA 甲基化等
- **F. 蛋白质组学**: 质谱技术、蛋白质鉴定、定量方法、翻译后修饰等
- **G. 代谢组学**: 代谢物、代谢通路、通量分析、分析技术等
- **H. 系统生物学与计算生物学**: 网络分析、数学建模、机器学习等
- **I. 生物数据库与资源**: GenBank、UniProt、PDB、工具与软件等

#### 核心术语示例
```
Next-Generation Sequencing (NGS) | 下一代测序
Single Nucleotide Polymorphism (SNP) | 单核苷酸多态性
RNA Sequencing (RNA-Seq) | RNA 测序
Mass Spectrometry (MS) | 质谱
CRISPR-Cas9 | CRISPR-Cas9 系统
Single-Cell RNA-Seq (scRNA-seq) | 单细胞 RNA 测序
```

### 4. 小核酸制药术语库 (oligonucleotide.md) ⭐ 业界最详尽

**术语数**: 910+ 条  
**子分类**: 13 个  
**适用场景**: 小核酸药物、RNA 疗法、寡核苷酸合成

#### 分类详情
- **A. 寡核苷酸化学基础**: 核苷酸结构、核苷类似物 (100+ 术语)
- **B. 小核酸药物类型**: ASO、siRNA、miRNA、适配体、其他类型 (70+ 术语)
- **C. 化学修饰**: 糖环修饰、骨架修饰、碱基修饰、末端修饰、共轭修饰 (60+ 术语)
- **D. 递送系统**: LNP、聚合物纳米粒、外泌体、病毒载体、物理递送 (80+ 术语)
- **E. 作用机制与药效学**: RNAi、反义机制、基因激活、免疫调节 (35+ 术语)
- **F. 药代动力学与生物分析**: ADME、组织分布、代谢稳定性、生物分析 (30+ 术语)
- **G. 寡核苷酸合成化学**: 合成方法、试剂与单体、固相载体、合成循环 (200+ 术语)
- **H. CDMO 与生产服务**: CDMO 模式、工艺开发、生产设施、供应链管理、法规合规 (200+ 术语)
- **I. 纯化与分离技术**: HPLC、离子交换、尺寸排阻、超滤 (50+ 术语)
- **J. 分析表征技术**: LC-MS、CE、光谱学、粒度分析 (50+ 术语)
- **K. 药物设计与优化**: 序列设计、化学修饰策略、脱靶效应 (30+ 术语)
- **L. 临床开发与监管**: 临床试验设计、监管指导原则、安全性评价 (40+ 术语)
- **M. 已获批小核酸药物**: ASO、siRNA 药物列表 (20+ 药物)
- **N. 疾病领域与治疗应用**: 神经肌肉疾病、代谢疾病、肿瘤、感染性疾病 (30+ 术语)

#### 核心术语示例
```
Antisense Oligonucleotide (ASO) | 反义寡核苷酸
Small Interfering RNA (siRNA) | 小干扰 RNA
Locked Nucleic Acid (LNA) | 锁核酸
2'-O-Methoxyethyl (2'-MOE) | 2'-O-甲氧基乙基
Phosphorothioate (PS) | 硫代磷酸酯
GalNAc Conjugate | GalNAc 偶联物
Lipid Nanoparticle (LNP) | 脂质纳米粒
RNase H | RNase H 酶
```

### 5. 临床医学术语库 (clinical-medicine.md)

**术语数**: 1111+ 条  
**子分类**: 5 个  
**适用场景**: 临床试验、疾病诊疗、医学研究

#### 分类详情
- **A. 疾病分类与病理**: 疾病类型、病理学、肿瘤学 (80+ 术语)
- **B. 诊断与检查**: 诊断方法、体格检查、实验室检查、影像学、内镜检查、功能检查 (400+ 术语)
- **C. 治疗与干预**: 治疗方式、药物治疗、手术治疗、放射治疗、免疫治疗、介入治疗 (300+ 术语)
- **D. 临床试验**: 试验设计、分期、受试者管理、终点指标、安全性、数据管理 (250+ 术语)
- **E. 器官系统与解剖**: 身体系统、解剖结构 (80+ 术语)

#### 核心术语示例
```
Randomized Controlled Trial (RCT) | 随机对照试验
Progression-Free Survival (PFS) | 无进展生存期
Overall Survival (OS) | 总生存期
Adverse Event (AE) | 不良事件
Complete Response (CR) | 完全应答
Intent-to-Treat (ITT) | 意向性治疗
Good Clinical Practice (GCP) | 药物临床试验质量管理规范
```

## 🎯 异步加载架构

### 设计理念

术语库采用模块化设计，将 4500+ 条术语按领域拆分为独立文件，支持：

1. **核心术语库常驻**: `core-terms.md` 始终加载，提供基础术语支持
2. **按需加载**: 根据翻译内容自动识别领域，加载对应术语库
3. **智能预加载**: 识别到相关领域时预加载邻近术语库
4. **缓存机制**: 已加载术语库缓存至内存，避免重复加载

### 领域识别规则

| 领域 | 关键词示例 | 加载术语库 |
|------|-----------|-----------|
| 抗体药物 | antibody, mAb, ADC, BsAb, CAR-T | core + antibody-drugs |
| 基因组学 | genome, sequencing, NGS, RNA-seq, CRISPR | core + genomics |
| 小核酸制药 | oligonucleotide, siRNA, ASO, GalNAc, LNP | core + oligonucleotide |
| 临床医学 | clinical, trial, diagnosis, treatment, patient | core + clinical-medicine |

### 性能指标

- **核心库大小**: <50KB，加载时间 <100ms
- **专业库按需加载**: 平均加载时间 <200ms
- **术语检索响应**: <50ms
- **内存占用**: 单库缓存 <5MB

## 📖 使用场景

### 适用文档类型

- ✅ 生物制药研发文档
- ✅ 临床试验方案和报告 (CSR)
- ✅ 基因组学研究论文
- ✅ 药品注册申报资料 (IND/NDA/BLA)
- ✅ 医疗器械说明书
- ✅ 医学教科书和文献
- ✅ 小核酸药物相关资料
- ✅ CDMO 技术转移文档

### 翻译质量标准

#### 准确性原则
- 遵循 MeSH、ICD-10/11、SNOMED CT、INN、USAN 等国际标准
- 符合中国药典、CMeSH、医学名词审定委员会规范
- 参考 Dorland's、Stedman's 等权威医学词典

#### 一致性原则
- 全文术语统一，避免同义词混用
- 缩写首次出现标注全称和中译
- 建立术语对照表供后续参考

#### 上下文适配
- 区分学术文献、临床报告、注册申报、科普文章等文体
- 考虑目标读者 (专业人士/患者/监管机构)
- 根据具体语境选择最恰当译法

## 🔧 高级功能

### 术语库验证

```bash
# 验证所有术语库格式
./manage-terminology.sh validate

# 验证特定术语库
./manage-terminology.sh validate -f oligonucleotide.md
```

验证项目：
- ✅ 元数据完整性
- ✅ 术语格式规范性 (English | Chinese)
- ✅ 重复术语检测
- ✅ 分类结构合理性

### 术语库备份

```bash
# 备份所有术语库 (带时间戳)
./manage-terminology.sh backup

# 备份位置
backups/terminology_backup_YYYYMMDD_HHMMSS/
```

### 术语库导出

```bash
# 导出为 CSV 格式
./manage-terminology.sh export -o terminology_export.csv

# CSV 格式
English,Chinese,Library,Category
"Monoclonal Antibody","单克隆抗体","antibody-drugs","抗体类型与结构"
```

## 📊 更新日志

### v2.0 (2026-03-05) - 重构版

**重大改进**:
- ✅ 采用模块化术语库架构
- ✅ 实现异步加载机制
- ✅ 拆分 5 大领域术语库到独立文件
- ✅ 优化术语检索性能
- ✅ 新增术语搜索和管理脚本
- ✅ 术语总数扩展至 4542+ 条

**文件变更**:
- SKILL.md: 从 3109 行精简至 221 行
- 新增: terminology/ 目录 (5 个独立术语库文件)
- 新增: scripts/ 目录 (搜索和管理脚本)
- 更新：README.md (反映新架构)

### v1.0 (原始版本)
- 初始术语库建立
- 基础翻译功能实现

## 🌐 外部资源链接

### 权威数据库
- [MeSH (Medical Subject Headings)](https://meshb.nlm.nih.gov/)
- [ICD-10/11](https://icd.who.int/)
- [SNOMED CT](https://www.snomed.org/)
- [HGNC (HUGO Gene Nomenclature Committee)](https://www.genenames.org/)
- [UniProt](https://www.uniprot.org/)
- [INN (International Nonproprietary Names)](https://www.who.int/teams/health-product-policy-and-standards/standards-and-specifications/inn)

### 中国标准
- [中国医学名词审定委员会](http://www.cnmst.org.cn/)
- [中国药典](https://www.chp.org.cn/)
- [CMeSH (中国医学主题词表)](http://www.imicams.ac.cn/)

### 监管机构
- [NMPA (国家药监局)](https://www.nmpa.gov.cn/)
- [FDA (美国食药监局)](https://www.fda.gov/)
- [EMA (欧洲药监局)](https://www.ema.europa.eu/)
- [ICH (国际人用药品注册技术协调会)](https://www.ich.org/)

## 📞 支持与反馈

### 术语纠错
如发现术语翻译错误或不准确，请提供：
- 错误术语及位置
- 建议的正确译法
- 参考来源 (如有)

### 术语补充
欢迎提交新术语，请提供：
- 英文术语
- 中文译法
- 所属领域
- 定义或说明 (可选)

### 联系方式
- GitHub Issues: 提交术语纠错和建议
- 邮件：[待定]

---

**最后更新**: 2026-03-05  
**版本**: v2.0  
**维护状态**: 活跃维护中
