#!/bin/bash

# ============================================================================
# 生物医学翻译 Agent 安装检查脚本
# 用于验证技能安装的完整性和功能性
# ============================================================================
# 使用方法:
#   ./check-installation.sh
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="${SCRIPT_DIR}"
TERMINOLOGY_DIR="${SCRIPT_DIR}/terminology"
SCRIPTS_DIR="${SCRIPT_DIR}/scripts"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 计数器
CHECKS_PASSED=0
CHECKS_FAILED=0
CHECKS_WARNING=0

# 检查函数
check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    CHECKS_FAILED=$((CHECKS_FAILED + 1))
}

check_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    CHECKS_WARNING=$((CHECKS_WARNING + 1))
}

# 显示标题
echo -e "\n${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║     生物医学翻译 Agent - 安装检查工具                    ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}\n"

# 1. 检查核心文件
echo -e "${BLUE}[1/6] 检查核心文件...${NC}"

if [[ -f "${SKILL_DIR}/SKILL.md" ]]; then
    check_pass "SKILL.md 存在"
    
    # 检查文件大小
    size=$(wc -c < "${SKILL_DIR}/SKILL.md")
    if [[ $size -gt 1000 ]]; then
        check_pass "SKILL.md 大小正常 (${size} 字节)"
    else
        check_fail "SKILL.md 文件过小 (${size} 字节)"
    fi
else
    check_fail "SKILL.md 不存在"
fi

if [[ -f "${SKILL_DIR}/README.md" ]]; then
    check_pass "README.md 存在"
else
    check_fail "README.md 不存在"
fi

if [[ -f "${SKILL_DIR}/QUICKSTART.md" ]]; then
    check_pass "QUICKSTART.md 存在"
else
    check_warning "QUICKSTART.md 不存在 (可选)"
fi

# 2. 检查术语库目录
echo -e "\n${BLUE}[2/6] 检查术语库目录...${NC}"

if [[ -d "${TERMINOLOGY_DIR}" ]]; then
    check_pass "terminology 目录存在"
else
    check_fail "terminology 目录不存在"
fi

# 3. 检查术语库文件
echo -e "\n${BLUE}[3/6] 检查术语库文件...${NC}"

REQUIRED_FILES=(
    "core-terms.md"
    "antibody-drugs.md"
    "genomics.md"
    "oligonucleotide.md"
    "clinical-medicine.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [[ -f "${TERMINOLOGY_DIR}/${file}" ]]; then
        count=$(grep -c "^- " "${TERMINOLOGY_DIR}/${file}" 2>/dev/null || echo 0)
        check_pass "${file} 存在 (${count} 条术语)"
    else
        check_fail "${file} 不存在"
    fi
done

# 4. 检查脚本目录
echo -e "\n${BLUE}[4/6] 检查脚本目录...${NC}"

if [[ -d "${SCRIPTS_DIR}" ]]; then
    check_pass "scripts 目录存在"
else
    check_fail "scripts 目录不存在"
fi

# 5. 检查脚本文件
echo -e "\n${BLUE}[5/6] 检查脚本文件...${NC}"

if [[ -f "${SCRIPTS_DIR}/search-terminology.sh" ]]; then
    check_pass "search-terminology.sh 存在"
    
    # 检查执行权限
    if [[ -x "${SCRIPTS_DIR}/search-terminology.sh" ]]; then
        check_pass "search-terminology.sh 可执行"
    else
        check_warning "search-terminology.sh 缺少执行权限"
    fi
else
    check_fail "search-terminology.sh 不存在"
fi

if [[ -f "${SCRIPTS_DIR}/manage-terminology.sh" ]]; then
    check_pass "manage-terminology.sh 存在"
    
    # 检查执行权限
    if [[ -x "${SCRIPTS_DIR}/manage-terminology.sh" ]]; then
        check_pass "manage-terminology.sh 可执行"
    else
        check_warning "manage-terminology.sh 缺少执行权限"
    fi
else
    check_fail "manage-terminology.sh 不存在"
fi

# 6. 功能测试
echo -e "\n${BLUE}[6/6] 功能测试...${NC}"

# 测试术语搜索
if [[ -x "${SCRIPTS_DIR}/search-terminology.sh" ]]; then
    echo -n "测试术语搜索功能... "
    if "${SCRIPTS_DIR}/search-terminology.sh" antibody -n >/dev/null 2>&1; then
        check_pass "术语搜索功能正常"
    else
        check_fail "术语搜索功能异常"
    fi
fi

# 测试术语库统计
if [[ -x "${SCRIPTS_DIR}/manage-terminology.sh" ]]; then
    echo -n "测试术语库统计功能... "
    if "${SCRIPTS_DIR}/manage-terminology.sh" stats >/dev/null 2>&1; then
        check_pass "术语库统计功能正常"
    else
        check_fail "术语库统计功能异常"
    fi
fi

# 测试术语库验证
if [[ -x "${SCRIPTS_DIR}/manage-terminology.sh" ]]; then
    echo -n "测试术语库验证功能... "
    if "${SCRIPTS_DIR}/manage-terminology.sh" validate >/dev/null 2>&1; then
        check_pass "术语库验证功能正常"
    else
        check_fail "术语库验证功能异常"
    fi
fi

# 显示总结
echo -e "\n${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                    检查总结                               ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}\n"

echo -e "${GREEN}通过：${CHECKS_PASSED}${NC}"
echo -e "${RED}失败：${CHECKS_FAILED}${NC}"
echo -e "${YELLOW}警告：${CHECKS_WARNING}${NC}"
echo ""

# 根据检查结果提供建议
if [[ $CHECKS_FAILED -eq 0 ]]; then
    echo -e "${GREEN}✓ 所有检查通过！技能已正确安装。${NC}\n"
    
    if [[ $CHECKS_WARNING -gt 0 ]]; then
        echo -e "${YELLOW}⚠ 存在一些警告，但不影响基本功能使用。${NC}\n"
    fi
    
    echo -e "${BLUE}下一步操作：${NC}"
    echo "  1. 阅读 QUICKSTART.md 了解快速开始"
    echo "  2. 阅读 README.md 查看完整文档"
    echo "  3. 在 Trae IDE 中调用技能进行翻译"
    echo ""
    exit 0
else
    echo -e "${RED}✗ 存在关键问题，需要修复后才能使用。${NC}\n"
    
    echo -e "${BLUE}修复建议：${NC}"
    
    if [[ ! -f "${SKILL_DIR}/SKILL.md" ]]; then
        echo "  - 确保 SKILL.md 文件存在于正确位置"
    fi
    
    for file in "${REQUIRED_FILES[@]}"; do
        if [[ ! -f "${TERMINOLOGY_DIR}/${file}" ]]; then
            echo "  - 添加缺失的术语库文件：${file}"
        fi
    done
    
    if [[ ! -x "${SCRIPTS_DIR}/search-terminology.sh" ]]; then
        echo "  - 设置脚本执行权限：chmod +x scripts/*.sh"
    fi
    
    echo ""
    exit 1
fi
