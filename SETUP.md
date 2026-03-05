# bio-med-translator Skill 安装和配置指南

## 📦 完整安装流程

### 步骤 1: 安装 Openskills

首先确保已安装 openskills 命令行工具：

```bash
# 安装 openskills（如果尚未安装）
npm install -g openskills
```

### 步骤 2: 安装必要的 Skills

安装 bio-med-translator 依赖的文件处理 skills：

```bash
# 安装 docx skill（用于读取 Word 文档）
openskills install https://github.com/anthropics/skills.git -g -y

# 验证安装
openskills list
```

### 步骤 3: 安装 bio-med-translator Skill

```bash
# 进入 skills 目录
cd ~/.trae/skills

# 克隆或更新 bio-med-translator
git clone https://github.com/weiransoft/bio-med-translator.git
# 或如果已存在，拉取最新代码
cd bio-med-translator && git pull
```

### 步骤 4: 验证安装

运行安装检查脚本：

```bash
cd ~/.trae/skills/bio-med-translator
chmod +x check-installation.sh
./check-installation.sh
```

## 🔧 配置说明

### 自动配置

bio-med-translator 已预配置为自动调用以下 skills：

- **docx skill**: 自动识别并读取 .docx 文件
- **pdf skill**: 自动识别并读取 .pdf 文件
- **markdown skill**: 直接读取 .md 文件
- **excel skill**: 自动识别并读取 .xlsx/.xls 文件

无需手动配置，Agent 会根据文件扩展名自动调用对应的 skill。

### 手动配置（可选）

如果需要自定义配置，可以在 Trae IDE 中设置：

1. 打开 Trae IDE 设置
2. 导航到 Skills 配置
3. 确保以下 skills 已启用：
   - bio-med-translator
   - docx
   - pdf
   - markdown
   - excel

## 📝 使用方式

### 基本使用

直接在 Trae IDE 中调用 bio-med-translator：

```
用户：请翻译这个文件 `/path/to/document.docx`
```

Agent 会自动：
1. 识别文件类型为 .docx
2. 调用 docx skill 读取文件
3. 分析文档内容和领域
4. 加载对应的术语库
5. 执行专业翻译
6. 输出译文和术语对照表

### 批量翻译

```
用户：请翻译以下文件：
- /path/to/protocol.docx
- /path/to/report.pdf
- /path/to/data.xlsx
```

Agent 会逐个处理每个文件，并提供统一的术语表。

## 🔍 故障排查

### 问题 1: 无法读取 Word 文档

**症状**: 提示无法读取 .docx 文件

**解决方案**:
1. 确认 docx skill 已安装：`openskills list`
2. 检查文件路径是否正确
3. 确认文件未损坏：尝试用 Microsoft Word 打开
4. 检查文件权限：确保有读取权限

### 问题 2: PDF 文件无法解析

**症状**: PDF 文件读取失败或内容为空

**解决方案**:
1. 确认 pdf skill 已安装
2. 检查 PDF 是否为扫描版（需要 OCR 支持）
3. 确认 PDF 未加密（如加密需提供密码）
4. 尝试将 PDF 转换为文本格式

### 问题 3: 术语库未加载

**症状**: 翻译结果缺少专业术语支持

**解决方案**:
1. 检查术语库文件是否存在：
   ```bash
   ls -la ~/.trae/skills/bio-med-translator/terminology/
   ```
2. 运行术语库检查：
   ```bash
   ./scripts/manage-terminology.sh stats
   ```
3. 确认术语库文件完整（应有 5 个 .md 文件）

### 问题 4: 翻译质量不佳

**症状**: 术语翻译不准确或不一致

**解决方案**:
1. 确认已正确识别文档领域
2. 检查是否加载了对应的术语库
3. 手动指定期望的翻译策略：
   ```
   用户：请使用药典标准术语翻译这个文件
   ```
4. 查看术语对照表，确认关键术语译法

## 📊 性能优化

### 大文件处理

对于大型文档（>100 页）：

1. **分块处理**: Agent 会自动分块读取和翻译
2. **增量输出**: 翻译结果分段输出，避免等待
3. **后台处理**: 可在后台处理，完成后通知

### 批量翻译优化

对于多个文件：

1. **并行处理**: 支持同时处理多个文件
2. **术语共享**: 建立统一的跨文件术语表
3. **进度跟踪**: 实时显示处理进度

## 🆘 获取帮助

### 文档资源

- **SKILL.md**: 完整的 Agent 功能说明
- **README.md**: 使用指南和最佳实践
- **QUICKSTART.md**: 快速入门
- **INSTALL.md**: 详细安装说明

### 脚本工具

```bash
# 术语搜索
./scripts/search-terminology.sh "siRNA"

# 术语库统计
./scripts/manage-terminology.sh stats

# 安装检查
./check-installation.sh
```

### 社区支持

- GitHub Issues: 提交问题和功能建议
- 邮件支持：查看项目主页联系方式

## 📋 检查清单

安装完成后，请确认以下项目：

- [ ] openskills 已安装并可正常使用
- [ ] docx skill 已安装
- [ ] pdf skill 已安装
- [ ] bio-med-translator 已安装
- [ ] 术语库文件完整（5 个 .md 文件）
- [ ] 脚本工具有执行权限
- [ ] 测试文件翻译功能正常
- [ ] 术语查询功能正常

## 🎯 最佳实践

1. **始终提供完整文件路径**: 避免使用相对路径
2. **明确文档类型**: 如知道文档类型，可在请求中说明
3. **检查术语表**: 翻译完成后查看术语对照表
4. **批量处理**: 相关文档一起翻译，确保术语一致性
5. **反馈纠错**: 发现术语错误及时反馈

---

**版本**: v3.1  
**更新日期**: 2026-03-05  
**维护者**: bio-med-translator 团队
