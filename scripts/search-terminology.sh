#!/bin/bash

# ============================================================================
# 生物医学术语搜索脚本
# 用于在术语库中快速搜索和检索术语
# ============================================================================
# 使用方法:
#   ./search-terminology.sh <搜索词> [选项]
#
# 选项:
#   -a, --all         搜索所有术语库 (默认：只搜索核心库)
#   -c, --core        只搜索核心术语库
#   -C, --clinical    只搜索临床医学术语库
#   -g, --genomics    只搜索基因组学术语库
#   -o, --oligo       只搜索小核酸制药术语库
#   -A, --antibody    只搜索抗体药物术语库
#   -i, --ignore-case 忽略大小写
#   -e, --exact       精确匹配
#   -n, --count       只显示匹配数量
#   -h, --help        显示帮助信息
#
# 示例:
#   ./search-terminology.sh antibody
#   ./search-terminology.sh "gene expression" -a
#   ./search-terminology.sh CRISPR -g -i
#   ./search-terminology.sh siRNA -o --exact
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERMINOLOGY_DIR="${SCRIPT_DIR}/../terminology"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 默认选项
SEARCH_ALL=false
IGNORE_CASE=false
EXACT_MATCH=false
COUNT_ONLY=false
SPECIFIC_LIBRARY=""

# 显示帮助信息
show_help() {
    cat << EOF
生物医学术语搜索工具

用法：$(basename "$0") <搜索词> [选项]

选项:
  -a, --all          搜索所有术语库
  -c, --core         只搜索核心术语库 (A-Z)
  -C, --clinical     只搜索临床医学术语库
  -g, --genomics     只搜索基因组学术语库
  -o, --oligo        只搜索小核酸制药术语库
  -A, --antibody     只搜索抗体药物术语库
  -i, --ignore-case  忽略大小写
  -e, --exact        精确匹配
  -n, --count        只显示匹配数量
  -h, --help         显示帮助信息

示例:
  $(basename "$0") antibody                    # 在核心库中搜索 antibody
  $(basename "$0") "gene expression" -a        # 在所有库中搜索 gene expression
  $(basename "$0") CRISPR -g -i                # 在基因组学库中忽略大小写搜索
  $(basename "$0") siRNA -o --exact            # 在小核酸库中精确匹配
  $(basename "$0") "CAR-T" -A -n               # 在抗体库中计数匹配

EOF
}

# 搜索单个文件
search_file() {
    local file="$1"
    local pattern="$2"
    local grep_opts="$3"
    
    if [[ ! -f "$file" ]]; then
        echo -e "${RED}错误：文件不存在：$file${NC}" >&2
        return 1
    fi
    
    local filename=$(basename "$file")
    local library_name="${filename%.md}"
    
    echo -e "\n${BLUE}=== 搜索结果：${library_name} ===${NC}"
    
    if [[ "$COUNT_ONLY" == true ]]; then
        local count=$(grep $grep_opts -c "^- " "$file" 2>/dev/null || echo 0)
        local match_count=$(grep $grep_opts "$pattern" "$file" 2>/dev/null | wc -l)
        echo -e "${GREEN}匹配数：${match_count}${NC}"
    else
        # 搜索并高亮显示
        grep $grep_opts --color=always "$pattern" "$file" | head -20
        
        local total_matches=$(grep $grep_opts -c "$pattern" "$file" 2>/dev/null || echo 0)
        if [[ $total_matches -gt 20 ]]; then
            echo -e "${YELLOW}... 还有 $((total_matches - 20)) 条匹配 (共 $total_matches 条)${NC}"
        fi
    fi
}

# 主搜索函数
perform_search() {
    local search_term="$1"
    local grep_opts=""
    
    if [[ "$IGNORE_CASE" == true ]]; then
        grep_opts="-i"
    fi
    
    if [[ "$EXACT_MATCH" == true ]]; then
        grep_opts="$grep_opts -w"
    fi
    
    local start_time=$(date +%s.%N)
    
    if [[ "$SEARCH_ALL" == true ]]; then
        echo -e "${BLUE}在所有术语库中搜索：${search_term}${NC}"
        echo "==========================================="
        
        for lib in core-terms antibody-drugs genomics oligonucleotide clinical-medicine; do
            search_file "${TERMINOLOGY_DIR}/${lib}.md" "$search_term" "$grep_opts"
        done
    elif [[ -n "$SPECIFIC_LIBRARY" ]]; then
        search_file "${TERMINOLOGY_DIR}/${SPECIFIC_LIBRARY}.md" "$search_term" "$grep_opts"
    else
        # 默认只搜索核心库
        search_file "${TERMINOLOGY_DIR}/core-terms.md" "$search_term" "$grep_opts"
    fi
    
    local end_time=$(date +%s.%N)
    local elapsed=$(echo "$end_time - $start_time" | bc)
    echo -e "\n${YELLOW}搜索耗时：${elapsed}秒${NC}"
}

# 统计术语库
show_statistics() {
    echo -e "\n${BLUE}=== 术语库统计 ===${NC}"
    
    for lib in core-terms antibody-drugs genomics oligonucleotide clinical-medicine; do
        local file="${TERMINOLOGY_DIR}/${lib}.md"
        if [[ -f "$file" ]]; then
            local term_count=$(grep -c "^- " "$file" 2>/dev/null || echo 0)
            local line_count=$(wc -l < "$file")
            local file_size=$(du -h "$file" | cut -f1)
            
            printf "${GREEN}%-20s${NC} | 术语数：${YELLOW}%5d${NC} | 行数：%-6d | 大小：%-5s\n" \
                "${lib}" "$term_count" "$line_count" "$file_size"
        fi
    done
    
    echo ""
}

# 解析命令行参数
if [[ $# -eq 0 ]]; then
    show_help
    exit 0
fi

SEARCH_TERM=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -a|--all)
            SEARCH_ALL=true
            shift
            ;;
        -c|--core)
            SPECIFIC_LIBRARY="core-terms"
            shift
            ;;
        -C|--clinical)
            SPECIFIC_LIBRARY="clinical-medicine"
            shift
            ;;
        -g|--genomics)
            SPECIFIC_LIBRARY="genomics"
            shift
            ;;
        -o|--oligo)
            SPECIFIC_LIBRARY="oligonucleotide"
            shift
            ;;
        -A|--antibody)
            SPECIFIC_LIBRARY="antibody-drugs"
            shift
            ;;
        -i|--ignore-case)
            IGNORE_CASE=true
            shift
            ;;
        -e|--exact)
            EXACT_MATCH=true
            shift
            ;;
        -n|--count)
            COUNT_ONLY=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -s|--stats)
            show_statistics
            exit 0
            ;;
        -*)
            echo -e "${RED}未知选项：$1${NC}" >&2
            show_help
            exit 1
            ;;
        *)
            SEARCH_TERM="$1"
            shift
            ;;
    esac
done

if [[ -z "$SEARCH_TERM" ]]; then
    echo -e "${RED}错误：请提供搜索词${NC}" >&2
    show_help
    exit 1
fi

# 执行搜索
perform_search "$SEARCH_TERM"
