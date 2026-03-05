#!/bin/bash

# ============================================================================
# 生物医学术语库管理脚本
# 用于术语库的统计、验证、备份等管理功能
# ============================================================================
# 使用方法:
#   ./manage-terminology.sh <命令> [选项]
#
# 命令:
#   stats       显示术语库统计信息
#   validate    验证术语库格式
#   backup      备份术语库
#   diff        比较术语库版本差异
#   export      导出术语库为 CSV 格式
#   clean       清理术语库中的重复项
#   help        显示帮助信息
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERMINOLOGY_DIR="${SCRIPT_DIR}/../terminology"
BACKUP_DIR="${SCRIPT_DIR}/../backups"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 显示帮助信息
show_help() {
    cat << EOF
生物医学术语库管理工具

用法：$(basename "$0") <命令> [选项]

命令:
  stats       显示术语库统计信息
  validate    验证术语库格式和完整性
  backup      备份所有术语库
  diff        比较两个术语库文件的差异
  export      导出术语库为 CSV 格式
  clean       清理术语库中的重复项
  help        显示帮助信息

选项:
  -f, --file <文件>  指定操作的术语库文件
  -o, --output <文件> 输出文件路径
  -v, --verbose      显示详细信息

示例:
  $(basename "$0") stats                      # 显示所有术语库统计
  $(basename "$0") validate                   # 验证所有术语库
  $(basename "$0") validate -f genomics.md    # 验证特定术语库
  $(basename "$0") backup                     # 备份所有术语库
  $(basename "$0") export -o terms.csv        # 导出为 CSV
  $(basename "$0") diff file1.md file2.md     # 比较两个文件

EOF
}

# 统计术语库
show_statistics() {
    echo -e "\n${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║          生物医学术语库统计信息                           ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}\n"
    
    local total_terms=0
    local total_lines=0
    local total_size=0
    
    printf "${BLUE}%-25s | %-10s | %-10s | %-10s | %-10s${NC}\n" \
        "术语库名称" "术语数" "行数" "文件大小" "最后修改"
    echo "─────────────────────────────────────────────────────────────────"
    
    for lib in core-terms antibody-drugs genomics oligonucleotide clinical-medicine; do
        local file="${TERMINOLOGY_DIR}/${lib}.md"
        if [[ -f "$file" ]]; then
            local term_count=$(grep -c "^- " "$file" 2>/dev/null || echo 0)
            local line_count=$(wc -l < "$file")
            local file_size=$(du -h "$file" | cut -f1)
            local mod_time=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$file" 2>/dev/null || \
                           stat -c "%y" "$file" 2>/dev/null | cut -d' ' -f1)
            
            printf "${GREEN}%-25s${NC} | ${YELLOW}%10d${NC} | %10d | %-10s | %-10s\n" \
                "${lib}" "$term_count" "$line_count" "$file_size" "$mod_time"
            
            total_terms=$((total_terms + term_count))
            total_lines=$((total_lines + line_count))
        else
            printf "${RED}%-25s${NC} | 文件不存在\n" "${lib}"
        fi
    done
    
    echo "─────────────────────────────────────────────────────────────────"
    printf "${BLUE}%-25s${NC} | ${YELLOW}%10d${NC} | %10d\n" \
        "总计" "$total_terms" "$total_lines"
    echo ""
}

# 验证术语库格式
validate_library() {
    local file="$1"
    local errors=0
    local warnings=0
    
    echo -e "\n${BLUE}验证术语库：$(basename "$file")${NC}"
    echo "==========================================="
    
    if [[ ! -f "$file" ]]; then
        echo -e "${RED}错误：文件不存在：$file${NC}"
        return 1
    fi
    
    # 检查必需部分
    echo -n "检查元数据... "
    if grep -q "^## 元数据" "$file"; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗ 缺少元数据部分${NC}"
        errors=$((errors + 1))
    fi
    
    echo -n "检查术语格式... "
    local invalid_terms=$(grep "^- " "$file" | grep -v " | " | wc -l)
    if [[ $invalid_terms -eq 0 ]]; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${YELLOW}⚠ 发现 $invalid_terms 条术语格式不正确${NC}"
        warnings=$((warnings + 1))
        grep "^- " "$file" | grep -v " | " | head -5
    fi
    
    echo -n "检查重复术语... "
    local duplicates=$(grep "^- " "$file" | sort | uniq -d | wc -l)
    if [[ $duplicates -eq 0 ]]; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${YELLOW}⚠ 发现 $duplicates 条重复术语${NC}"
        warnings=$((warnings + 1))
        grep "^- " "$file" | sort | uniq -d | head -5
    fi
    
    echo -n "检查空行... "
    local empty_lines=$(grep -c "^$" "$file" || echo 0)
    echo "${empty_lines} 个空行"
    
    echo -n "检查分类结构... "
    local sections=$(grep -c "^## " "$file" || echo 0)
    echo "${sections} 个主要分类"
    
    echo -n "术语总数... "
    local term_count=$(grep -c "^- " "$file" || echo 0)
    echo -e "${GREEN}${term_count} 条${NC}"
    
    echo ""
    if [[ $errors -eq 0 && $warnings -eq 0 ]]; then
        echo -e "${GREEN}✓ 验证通过，无错误${NC}"
    else
        echo -e "${YELLOW}⚠ 发现 $errors 个错误，$warnings 个警告${NC}"
    fi
    
    return $errors
}

# 备份术语库
backup_libraries() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_path="${BACKUP_DIR}/terminology_backup_${timestamp}"
    
    echo -e "\n${BLUE}备份术语库...${NC}"
    echo "==========================================="
    
    mkdir -p "$backup_path"
    
    for lib in core-terms antibody-drugs genomics oligonucleotide clinical-medicine; do
        local file="${TERMINOLOGY_DIR}/${lib}.md"
        if [[ -f "$file" ]]; then
            cp "$file" "$backup_path/"
            echo -e "${GREEN}✓ 备份：${lib}.md${NC}"
        else
            echo -e "${YELLOW}⚠ 跳过：${lib}.md (文件不存在)${NC}"
        fi
    done
    
    # 备份 SKILL.md
    if [[ -f "${TERMINOLOGY_DIR}/../SKILL.md" ]]; then
        cp "${TERMINOLOGY_DIR}/../SKILL.md" "$backup_path/"
        echo -e "${GREEN}✓ 备份：SKILL.md${NC}"
    fi
    
    echo ""
    echo -e "${GREEN}备份完成：${backup_path}${NC}"
    echo "备份大小：$(du -sh "$backup_path" | cut -f1)"
}

# 导出为 CSV
export_to_csv() {
    local output_file="$1"
    
    echo -e "\n${BLUE}导出术语库为 CSV...${NC}"
    echo "==========================================="
    
    echo "English,Chinese,Library,Category" > "$output_file"
    
    for lib in core-terms antibody-drugs genomics oligonucleotide clinical-medicine; do
        local file="${TERMINOLOGY_DIR}/${lib}.md"
        if [[ -f "$file" ]]; then
            local current_category=""
            
            while IFS= read -r line; do
                # 检测分类标题
                if [[ "$line" =~ ^###\ (.+) ]]; then
                    current_category="${BASH_REMATCH[1]}"
                fi
                
                # 提取术语
                if [[ "$line" =~ ^-\ (.+)\ \|\ (.+) ]]; then
                    local english="${BASH_REMATCH[1]}"
                    local chinese="${BASH_REMATCH[2]}"
                    
                    # 清理文本
                    english=$(echo "$english" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                    chinese=$(echo "$chinese" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                    
                    # 写入 CSV
                    echo "\"${english}\",\"${chinese}\",\"${lib}\",\"${current_category}\"" >> "$output_file"
                fi
            done < "$file"
            
            echo -e "${GREEN}✓ 导出：${lib}.md${NC}"
        fi
    done
    
    local count=$(wc -l < "$output_file")
    count=$((count - 1)) # 减去标题行
    
    echo ""
    echo -e "${GREEN}导出完成：${output_file}${NC}"
    echo "术语总数：${count}"
    echo "文件大小：$(du -h "$output_file" | cut -f1)"
}

# 清理重复项
clean_duplicates() {
    local file="$1"
    
    echo -e "\n${BLUE}清理重复术语：$(basename "$file")${NC}"
    echo "==========================================="
    
    if [[ ! -f "$file" ]]; then
        echo -e "${RED}错误：文件不存在：$file${NC}"
        return 1
    fi
    
    local before_count=$(grep -c "^- " "$file" || echo 0)
    
    # 提取术语行，去重，写回文件
    local temp_file=$(mktemp)
    
    # 保留非术语行
    grep -v "^- " "$file" > "$temp_file"
    
    # 添加去重后的术语行
    grep "^- " "$file" | sort -u >> "$temp_file"
    
    # 替换原文件
    mv "$temp_file" "$file"
    
    local after_count=$(grep -c "^- " "$file" || echo 0)
    local removed=$((before_count - after_count))
    
    echo -e "${GREEN}清理完成${NC}"
    echo "清理前：${before_count} 条术语"
    echo "清理后：${after_count} 条术语"
    echo -e "${YELLOW}移除：${removed} 条重复术语${NC}"
}

# 主程序
if [[ $# -eq 0 ]]; then
    show_help
    exit 0
fi

COMMAND="$1"
shift

case $COMMAND in
    stats)
        show_statistics
        ;;
    validate)
        if [[ "$1" == "-f" || "$1" == "--file" ]]; then
            validate_library "${TERMINOLOGY_DIR}/$2"
        else
            for lib in core-terms antibody-drugs genomics oligonucleotide clinical-medicine; do
                validate_library "${TERMINOLOGY_DIR}/${lib}.md"
            done
        fi
        ;;
    backup)
        backup_libraries
        ;;
    diff)
        if [[ -n "$1" && -n "$2" ]]; then
            diff "$1" "$2" | head -50
        else
            echo -e "${RED}请提供两个要比较的文件${NC}"
            exit 1
        fi
        ;;
    export)
        output_file="terminology_export.csv"
        while [[ $# -gt 0 ]]; do
            case $1 in
                -o|--output)
                    output_file="$2"
                    shift 2
                    ;;
                *)
                    shift
                    ;;
            esac
        done
        export_to_csv "$output_file"
        ;;
    clean)
        if [[ -n "$1" ]]; then
            clean_duplicates "${TERMINOLOGY_DIR}/$1"
        else
            echo -e "${RED}请指定要清理的文件${NC}"
            exit 1
        fi
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}未知命令：$COMMAND${NC}"
        show_help
        exit 1
        ;;
esac
