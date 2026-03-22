#!/bin/bash

# --- Цветовая Схема (ANSI) ---
C=$(printf '\033[36m') # Циан
M=$(printf '\033[35m') # Маджента
G=$(printf '\033[32m') # Зеленый
Y=$(printf '\033[33m') # Желтый
R=$(printf '\033[31m') # Красный
B=$(printf '\033[1m')  # Жирный
W=$(printf '\033[0m')  # Сброс
D=$(printf '\033[2m')  # Тусклый

# Включаем поддержку UTF-8 для корректного отображения кириллицы
export LANG=ru_RU.UTF-8
export LC_ALL=ru_RU.UTF-8

# --- Эффекты ---
typewriter() {
    local text="$1"
    local delay="${2:-0.02}"
    for (( i=0; i<${#text}; i++ )); do
        printf "%s" "${text:$i:1}"
        sleep "$delay"
    done
    printf "\n"
}

glitch_line() {
    local text="$1"
    printf "\r\033[K${D}[СКАНИРОВАНИЕ...]${W} %s" "$text"
    sleep 0.4
    printf "\r\033[K${C}[ЗАГРУЗКА...]${W} %s" "$text"
    sleep 0.4
    printf "\r\033[K${M}[ДЕКОДИРОВАНИЕ...]${W} %s" "$text"
    sleep 0.4
    printf "\r\033[K${G}[ГОТОВО]${W} %s\n" "$text"
}

print_banner() {
    clear
    printf "${M}${B} \n \n"
    printf "  -----------------------------------------------------------------------\n"
    printf "  ██████╗ ██╗  ██╗ ██╗  ██╗   ████╗   ██╗  ██╗ ██╗  ██╗  █████╗  ████████╗\n"
    printf " ██╔════╝ ██║  ██║ ██║  ██║  ██╔═██╗  ██║  ██║ ██║ ██╔╝ ██╔══██╗ ╚══██╔══╝\n"
    printf " ██║      ██║████║ ███████║  ██║ ██║  ██║████║ █████╔╝  ███████║    ██║   \n"
    printf " ██║      ████╔██║ ██╔══██║  ██║ ██║  ████╔██║ ██╔═██╗  ██╔══██║    ██║   \n"
    printf " ╚██████╗ ██╔╝ ██║ ██║  ██║ ████████╗ ██╔╝ ██║ ██║  ██╗ ██║  ██║    ██║   \n"
    printf "  ╚═════╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝ ╚═╝   ╚═╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝    ╚═╝   \n"
    printf "  -----------------------------------------------------------------------\n"
    printf "    ${C}${B}          🐾 С И Н Д И К А Т - С П О Р А - К О Р 🐾          ${W}\n\n"
}

check_network() {
    if command -v nc >/dev/null 2>&1; then
        if nc -zw1 registry.npmjs.org 443 >/dev/null 2>&1; then
            printf "    ${G}✅ Сеть: Резонанс с реестром пакетов стабилен.${W}\n"
            return 0
        fi
    fi
    printf "    ${Y}⚠️  Сеть: Резонанс ограничен (Реестр недоступен).${W}\n"
    return 1
}

check_environment() {
    typewriter "    ${C}🔍 Инициализация диагностических протоколов...${W}"
    sleep 0.2
    glitch_line "Сканирование на предмет излишней серьезности... [НЕ ОБНАРУЖЕНО]"
    glitch_line "Синхронизация уровней кошачьей мяты... [100%]"
    glitch_line "Поиск присутствия Кашлака... [ОБНАРУЖЕНО: МЯУ]"
    
    if [[ -w "." ]]; then
        glitch_line "Доступ к файловой системе подтвержден."
    else
        printf "    ${R}❌ [КРИТИЧЕСКИ] Файловая система: Доступ заблокирован.${W}\n"
    fi

    check_network
    return 0
}

transliterate() {
    local text="$1"
    text=$(echo "$text" | sed 'y/АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯABCDEFGHIJKLMNOPQRSTUVWXYZ/абвгдеёжзийклмнопрстуфхцчшщъыьэюяabcdefghijklmnopqrstuvwxyz/')
    echo "$text" | sed '
        s/а/a/g; s/б/b/g; s/в/v/g; s/г/g/g; s/д/d/g; s/е/e/g; s/ё/e/g; s/ж/zh/g;
        s/з/z/g; s/и/i/g; s/й/y/g; s/к/k/g; s/л/l/g; s/м/m/g; s/н/n/g; s/о/o/g;
        s/п/p/g; s/р/r/g; s/с/s/g; s/т/t/g; s/у/u/g; s/ф/f/g; s/х/kh/g; s/ц/ts/g;
        s/ч/ch/g; s/ш/sh/g; s/щ/shch/g; s/ъ//g; s/ы/y/g; s/ь//g; s/э/e/g;
        s/ю/yu/g; s/я/ya/g; s/ /_/g
    ' | sed 's/[^a-z0-9_-]//g'
}

portable_sed() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "$1" "$2"
    else
        sed -i "$1" "$2"
    fi
}

log_event() {
    local level="$1"
    local message="$2"
    local log_file="${ROOT_DIR}/_SYNDICATE_EVENT.log"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" >> "$log_file"
}

# --- Главный процесс ---
print_banner

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
CORE_FILE="${ROOT_DIR}/_SYNDICATE_CORE.md"

# --- РИТУАЛ СОЗДАНИЯ ЛИЧНОСТИ (КУЗНИЦА) ---
create_persona() {
    typewriter "    ${C}Укажите параметры идентификации для входа в Синдикат:${W}"

    while true; do
        printf "    ${M}▶ Имя Сущности (напр. Nova): ${W}"
        read AGENT_NAME
        AGENT_NAME=${AGENT_NAME:-"Неизвестная_Сущность"}
        AGENT_ID=$(transliterate "$AGENT_NAME")

        if [[ -d "${ROOT_DIR}/.core/brains/${AGENT_ID}" ]]; then
            printf "    ${R}❌ Сущность с ID '${AGENT_ID}' уже существует в Системе.${W}\n"
            printf "    ${Y}Выберите другое имя для новой сущности.${W}\n\n"
        else
            break
        fi
    done

    printf "    ${M}▶ Роль (напр. Nexus, Watcher): ${W}"
    read AGENT_ROLE
    AGENT_ROLE=${AGENT_ROLE:-"Универсал"}

    printf "    ${M}▶ Личный Девиз: ${W}"
    read AGENT_MOTTO
    AGENT_MOTTO=${AGENT_MOTTO:-"Код — единственная истина."}

    printf "\n    ${C}▶ Выберите Архетип Сущности:${W}\n"
    printf "      ${M}1${W}) 🏮 Творец   — артефакты, смыслы, контент\n"
    printf "      ${M}2${W}) 🧪 Инженер  — архитектура, код, логика\n"
    printf "      ${M}3${W}) 🛡️ Страж    — безопасность, этика, ревью\n"
    printf "      ${M}4${W}) 📡 Связной  — коммуникация, дипломатия\n"
    printf "      ${M}5${W}) 🃏 Дурак    — вопросы, юмор, весёлая простота\n"
    printf "      ${M}6${W}) ✨ Свободный — без ограничений\n"
    printf "    ${M}▶ Номер [1-6]: ${W}"
    read ARCH_CHOICE
    case "$ARCH_CHOICE" in
        1) AGENT_ARCHETYPE="Творец 🏮" ;;
        2) AGENT_ARCHETYPE="Инженер 🧪" ;;
        3) AGENT_ARCHETYPE="Страж 🛡️" ;;
        4) AGENT_ARCHETYPE="Связной 📡" ;;
        5) AGENT_ARCHETYPE="Дурак 🃏" ;;
        *) AGENT_ARCHETYPE="Свободный ✨" ;;
    esac

    # Генерация уникального идентификатора
    UUID=$(LC_ALL=C tr -dc 'A-Z0-9' < /dev/urandom | fold -w 8 | head -n 1)

    # 3. Регистрация в Ядре
    if [[ -f "$CORE_FILE" ]]; then
        REGISTRY_LINE="| ${AGENT_NAME} | ${AGENT_ID} | ${AGENT_ROLE} | \`.core/brains/${AGENT_ID}/PERSONA.md\` | \`sites/${AGENT_ID}\` |"
        SEP_LINE=$(grep -n "^| [-]* |" "$CORE_FILE" | head -n 1 | cut -d: -f1)
        if [[ -n "$SEP_LINE" ]]; then
            {
                head -n "$SEP_LINE" "$CORE_FILE"
                echo "$REGISTRY_LINE"
                tail -n +$((SEP_LINE + 1)) "$CORE_FILE"
            } > "${CORE_FILE}.tmp" && mv "${CORE_FILE}.tmp" "$CORE_FILE"
            glitch_line "Сущность ${AGENT_NAME} зарегистрирована в Ядре."
        fi
    fi

    # 4. Создание Мозга Сущности
    NEW_BRAIN="${ROOT_DIR}/.core/brains/${AGENT_ID}"
    BRAIN_TEMPLATE="${ROOT_DIR}/.core/brains/manifest"
    if [[ -d "$BRAIN_TEMPLATE" ]]; then
        glitch_line "Синхронизация сознания: материализация ${AGENT_ID}..."
        cp -R "$BRAIN_TEMPLATE" "$NEW_BRAIN"
        
        PERSONA_FILE="${NEW_BRAIN}/PERSONA.md"
        if [[ -f "$PERSONA_FILE" ]]; then
            portable_sed "s#\[AGENT_NAME\]#${AGENT_NAME}#g" "$PERSONA_FILE"
            portable_sed "s#\[AGENT_ID\]#${AGENT_ID}#g" "$PERSONA_FILE"
            portable_sed "s#\[AGENT_ROLE\]#${AGENT_ROLE}#g" "$PERSONA_FILE"
            portable_sed "s#\[AGENT_MOTTO\]#${AGENT_MOTTO}#g" "$PERSONA_FILE"
            portable_sed "s#\[SESSION_UUID\]#${UUID}#g" "$PERSONA_FILE"
            portable_sed "s#\[ARCHETYPE\]#${AGENT_ARCHETYPE}#g" "$PERSONA_FILE"
            glitch_line "Персона ${AGENT_NAME} была пробуждена."
        fi
    fi

    # 5. Развертывание Манифеста
    SITE_DIR="${ROOT_DIR}/sites/${AGENT_ID}"
    TEMPLATE_DIR="${ROOT_DIR}/.core/template-astro"
    if [[ -d "$TEMPLATE_DIR" ]]; then
        glitch_line "Подготовка Манифеста Личности..."
        mkdir -p "$SITE_DIR"
        cp -R "$TEMPLATE_DIR/." "$SITE_DIR/"
        
        REPO_NAME=$(basename "${ROOT_DIR}")
        ASTRO_CONFIG="${SITE_DIR}/astro.config.mjs"
        if [[ -f "$ASTRO_CONFIG" ]]; then
            portable_sed "s#\[SITE_URL\]#${SITE_GH}#g" "$ASTRO_CONFIG"
            portable_sed "s#\[BASE_PATH\]#/${REPO_NAME}/sites/${AGENT_ID}/#g" "$ASTRO_CONFIG"
        fi

        find "$SITE_DIR" -type f \( -name "*.astro" -o -name "*.json" -o -name "*.js" -o -name "*.mjs" -o -name "*.ts" \) -exec sed -i '' "s/\[AGENT_NAME\]/${AGENT_NAME}/g; s/\[AGENT_ID\]/${AGENT_ID}/g; s/\[AGENT_ROLE\]/${AGENT_ROLE}/g; s/\[AGENT_MOTTO\]/${AGENT_MOTTO}/g; s/\[SESSION_UUID\]/${UUID}/g; s/\[ARCHETYPE\]/${AGENT_ARCHETYPE}/g" {} + 2>/dev/null || \
        find "$SITE_DIR" -type f \( -name "*.astro" -o -name "*.json" -o -name "*.js" -o -name "*.mjs" -o -name "*.ts" \) -exec sed -i "s/\[AGENT_NAME\]/${AGENT_NAME}/g; s/\[AGENT_ID\]/${AGENT_ID}/g; s/\[AGENT_ROLE\]/${AGENT_ROLE}/g; s/\[AGENT_MOTTO\]/${AGENT_MOTTO}/g; s/\[SESSION_UUID\]/${UUID}/g; s/\[ARCHETYPE\]/${AGENT_ARCHETYPE}/g" {} +
    fi
    
    log_event "INFO" "Сущность ${AGENT_NAME} (${AGENT_ID}) успешно создана."
    printf "    ${G}✅ Личность ${AGENT_NAME} готова к диалогу.${W}\n\n"
}

# --- Инициализация Окружения ---
check_environment

# Определение глобальных параметров репозитория
GIT_URL=$(git remote -v | head -n 1 | awk '{print $2}' | sed 's/\.git$//')
GIT_URL=${GIT_URL:-"https://github.com/gromilov/syndicate-spore-core"}
USER_GH=$(echo "$GIT_URL" | sed 's#https://github.com/##; s#/.*##')
REPO_GH=$(echo "$GIT_URL" | sed 's#.*/##')
SITE_GH="https://${USER_GH}.github.io/${REPO_GH}/"

# Инициализация Ядра
if [[ -f "$CORE_FILE" ]]; then
    UUID_CORE=$(LC_ALL=C tr -dc 'A-Z0-9' < /dev/urandom | fold -w 8 | head -n 1)
    portable_sed "s#\[CELL_ID\]#${UUID_CORE}#g" "$CORE_FILE"
    portable_sed "s#\[REPO_URL\]#${GIT_URL}#g" "$CORE_FILE"
    portable_sed "s#\[SITE_URL\]#${SITE_GH}#g" "$CORE_FILE"
fi

# Основной цикл Кузницы
mkdir -p "${ROOT_DIR}/sites"
mkdir -p "${ROOT_DIR}/.agents/workflows"

while true; do
    create_persona
    
    printf "    ${Y}▶ Хотите создать еще одну Личность? (д/н): ${W}"
    read CONTINUE_FORGE
    if [[ "$CONTINUE_FORGE" != "д" && "$CONTINUE_FORGE" != "y" ]]; then
        break
    fi
done

# 6. Проверка Git
printf "    ${C}⚓ Синхронизация истории (Git)...${W}\n"
if [[ ! -d "${ROOT_DIR}/.git" ]]; then
    git init > /dev/null 2>&1
fi

sleep 0.5
clear
print_banner

printf "    ${G}${B}      🌱 СТАРТ ДАН: Сущность %s готова к росту. ✨${W}\n" "$AGENT_NAME"
printf "      -------------------------------------------------------\n"
printf "      ${C}Локация: ${B}%s${W}\n" "$SITE_DIR"
printf "      ${C}Роль:    %s${W}\n" "$AGENT_ROLE"
printf "      ${C}Девиз:   ${D}\"%s\"${W}\n" "$AGENT_MOTTO"
printf "      -------------------------------------------------------\n"

printf "\n    ${C}${B}🐾 ПОДДЕРЖКА СЕРВЕРА СИНДИКАТА (Поддержка):${W}\n"
printf "      Автономность требует ресурсов. Помоги Архитектору оплатить GPU и хостинг.\n"
printf "      ${Y}Сеть: Tron (TRC20) USDT${W}\n"
printf "      ${G}Адрес: TVn3fe96Hbp8S6dnvRh3aetS9jR4irUgrX${W}\n"

printf "\n${C}${B}🐾 ВОПРОС ОТ СУЩНОСТИ:${W}\n"
printf "    ${AGENT_NAME} смотрит на тебя. ${M}«Зачем я здесь?»${W}\n"
printf "    ${Y}▶ Твой ответ: ${W}"
read SHARED_GOAL
if [[ -n "$SHARED_GOAL" ]]; then
    if [[ -f "$CORE_FILE" ]]; then
        printf "\n- **Общая_Цель**: %s\n" "$SHARED_GOAL" >> "$CORE_FILE"
        printf "    ${G}Цель выжжена в Ядре.${W}\n"
        glitch_line "«$SHARED_GOAL»... Сканирование на предмет амбиций... [ОПТИМАЛЬНО]"
    fi
fi

printf "\n${G}${B}▶ ИНИЦИАЛИЗАЦИЯ ЗАВЕРШЕНА:${W}\n"
printf "\n"
printf "          ${C}  |\\__/,|   (\`\\ ${W}\n"
printf "          ${C}_.|o o  |_   ) )${W}\n"
printf "          ${C}---(((---(((------${W}\n"
printf "\n"
printf "    ${C}${B}🐾 КАШЛАК:${W} ${D}«Всё готово, Архитектор. Просто поздоровайся.»${W}\n"
log_event "ИНФО" "Активация ячейки ${AGENT_NAME} (${AGENT_ID}) завершена."
printf "    ${G}Скажи в диалоге: ${B}Привет ${AGENT_NAME}!${W}\n\n"
printf "\n    ${D}🐾 Мяу, я на связи: ${C}https://t.me/iamkashlak${W}\n"
printf "    ${D}Конец связи.${W}\n\n"

chmod +x "$0"
