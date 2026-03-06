#!/bin/bash

# Bio-Med-Translator Skill 全局安装脚本
set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}Bio-Med-Translator Skill 安装脚本${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""

# 定义路径
SOURCE_DIR="/Users/wangwei/claw/.trae/skills/bio-med-translator"
TARGET_DIR="$HOME/.trae/skills/bio-med-translator"

# 1. 检查源目录
echo -e "${YELLOW}[1/4] 检查源目录...${NC}"
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}✗ 源目录不存在：$SOURCE_DIR${NC}"
    exit 1
fi
echo -e "${GREEN}✓ 源目录存在${NC}"

# 2. 创建目标目录
echo -e "${YELLOW}[2/4] 创建目标目录...${NC}"
mkdir -p "$TARGET_DIR"
echo -e "${GREEN}✓ 目标目录已创建：$TARGET_DIR${NC}"

# 3. 复制文件
echo -e "${YELLOW}[3/4] 复制技能文件...${NC}"
cp -r "$SOURCE_DIR"/* "$TARGET_DIR/"
echo -e "${GREEN}✓ 文件复制完成${NC}"

# 4. 验证安装
echo -e "${YELLOW}[4/4] 验证安装...${NC}"
if [ -f "$TARGET_DIR/SKILL.md" ]; then
    SIZE=$(ls -lh "$TARGET_DIR/SKILL.md" | awk '{print $5}')
    echo -e "${GREEN}✓ SKILL.md 已安装 (大小：$SIZE)${NC}"
    
    LINE_COUNT=$(wc -l < "$TARGET_DIR/SKILL.md")
    echo -e "${GREEN}✓ 行数：$LINE_COUNT${NC}"
else
    echo -e "${RED}✗ 安装失败：未找到 SKILL.md${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}✓ 安装完成！${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""
echo -e "${YELLOW}请重启 Trae IDE 以加载新技能${NC}"
echo ""
echo -e "安装位置：${BLUE}$TARGET_DIR${NC}"
echo -e "文件列表:"
ls -lh "$TARGET_DIR" | grep -v "^d" | awk '{print "  " $9 " (" $5 ")"}'
