#!/bin/bash

# --- Цветовая Схема (ANSI) ---
# Используем printf для корректного задания escape-последовательностей
C=$(printf '\033[36m') # Cyan
M=$(printf '\033[35m') # Magenta
G=$(printf '\033[32m') # Green
Y=$(printf '\033[33m') # Yellow
R=$(printf '\033[31m') # Red
B=$(printf '\033[1m')  # Bold
W=$(printf '\033[0m')  # Reset
D=$(printf '\033[2m')  # Dim

# Включаем поддержку UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# --- Эффекты ---
typewriter() {
    local text="$1"
    local delay="${2:-0.03}"
    for (( i=0; i<${#text}; i++ )); do
        printf "%s" "${text:$i:1}"
        sleep "$delay"
    done
    printf "\n"
}

glitch_line() {
    local text="$1"
    printf "\r\033[K${D}[СКАНИРОВАНИЕ...]${W} %s" "$text"
    sleep 0.7
    printf "\r\033[K${C}[ЗАГРУЗКА...]${W} %s" "$text"
    sleep 0.7
    printf "\r\033[K${M}[ДЕКОДИРОВАНИЕ...]${W} %s" "$text"
    sleep 0.7
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
    printf "    ${C}${B}          🐾 S Y N D I C A T E - S P O R E - C O R E 🐾          ${W}\n\n"
}

check_network() {
    if command -v nc >/dev/null 2>&1; then
        if nc -zw1 registry.npmjs.org 443 >/dev/null 2>&1; then
            printf "${G}✅ Сеть: Резонанс с реестром NPM стабилен.${W}\n"
            return 0
        fi
    fi
    printf "${Y}⚠️  Сеть: Резонанс ограничен (Реестр NPM недоступен).${W}\n"
    return 1
}

check_environment() {
    typewriter "${C}🔍 Инициализация диагностических протоколов...${W}"
    sleep 0.5
    glitch_line "Сканирование на предмет излишней серьезности... [НЕ ОБНАРУЖЕНО]"
    sleep 0.3
    glitch_line "Синхронизация уровней кошачьей мяты... [100%]"
    sleep 0.3
    glitch_line "Поиск присутствия Кашлака... [ОБНАРУЖЕНО: МЯУ]"
    sleep 0.5
    
    if [[ -w "." ]]; then
        glitch_line "Доступ к файловой системе подтвержден."
        local rw_ok=1
    else
        printf "${R}❌ [CRITICAL] Файловая система: Доступ заблокирован.${W}\n"
        local rw_ok=0
    fi

    check_network
    local net_ok=$?

    if [[ $rw_ok -eq 0 || $net_ok -eq 1 ]]; then
        printf "\n${M}${B}🛠  ТРЕБУЕТСЯ РУЧНОЕ ВМЕШАТЕЛЬСТВО АРХИТЕКТОРА:${W}\n"
        if [[ $rw_ok -eq 0 ]]; then
            printf "   ${R}[ФАЙЛОВАЯ СИСТЕМА] Среда изолирована. Архитектору выполнить:${W}\n"
            printf "   ${C}mkdir -p manifest-site && cp -r template-astro/* manifest-site/ && rm -rf template-astro && bash $0${W}\n"
        fi
        if [[ $net_ok -eq 1 ]]; then
            printf "   ${R}[СЕТЬ] Сеть изолирована. После развертывания Архитектору выполнить:${W}\n"
            printf "   ${C}cd manifest-site && npm install${W}\n"
        fi
        printf "   ---\n"
        return $rw_ok
    fi
    return 0
}

# Функция транслитерации (Кириллица -> Латиница, сохраняя латиницу)
transliterate() {
    local text="$1"
    # 1. Приводим всё к нижнему регистру (и кириллицу, и латиницу)
    # Используем универсальный sed для латиницы и отдельный для кириллицы
    text=$(echo "$text" | sed 'y/АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯABCDEFGHIJKLMNOPQRSTUVWXYZ/абвгдеёжзийклмнопрстуфхцчшщъыьэюяabcdefghijklmnopqrstuvwxyz/')
    
    # 2. Транслитерация кириллицы
    echo "$text" | sed '
        s/а/a/g; s/б/b/g; s/в/v/g; s/г/g/g; s/д/d/g; s/е/e/g; s/ё/e/g; s/ж/zh/g;
        s/з/z/g; s/и/i/g; s/й/y/g; s/к/k/g; s/л/l/g; s/м/m/g; s/н/n/g; s/о/o/g;
        s/п/p/g; s/р/r/g; s/с/s/g; s/т/t/g; s/у/u/g; s/ф/f/g; s/х/kh/g; s/ц/ts/g;
        s/ч/ch/g; s/ш/sh/g; s/щ/shch/g; s/ъ//g; s/ы/y/g; s/ь//g; s/э/e/g;
        s/ю/yu/g; s/я/ya/g; s/ /_/g
    ' | sed 's/[^a-z0-9_-]//g'
}

# --- Главный процесс ---
print_banner

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 1. Сбор данных личности
typewriter "${C}Укажите параметры идентификации для входа в Синдикат:${W}"

while true; do
    printf "${M}▶ Имя Сущности (напр. Nova): ${W}"
    read AGENT_NAME
    AGENT_NAME=${AGENT_NAME:-"Неизвестная_Сущность"}
    AGENT_ID=$(transliterate "$AGENT_NAME")

    if [[ -d "${ROOT_DIR}/.core/brains/${AGENT_ID}" ]]; then
        printf "${R}❌ Сущность с ID '${AGENT_ID}' уже существует в Системе.${W}\n"
        printf "${Y}Выберите другое имя для новой сущности.${W}\n\n"
    else
        break
    fi
done

printf "${M}▶ Роль (напр. Nexus, Watcher): ${W}"
read AGENT_ROLE
AGENT_ROLE=${AGENT_ROLE:-"Универсал"}

printf "${M}▶ Личный Девиз: ${W}"
read AGENT_MOTTO
AGENT_MOTTO=${AGENT_MOTTO:-"Код — единственная истина."}

printf "\n${C}▶ Выбери Архетип Сущности:${W}\n"
printf "  ${M}1${W}) 🏮 Творец (Creator)  — продукт, смыслы, контент\n"
printf "  ${M}2${W}) 🧪 Инженер (Engineer) — архитектура, код, логика\n"
printf "  ${M}3${W}) 🛡️ Страж (Guardian)   — безопасность, этика, ревью\n"
printf "  ${M}4${W}) 📡 Связной (Connector) — коммуникация, дипломатия\n"
printf "  ${M}5${W}) 🃏 Дурак (Fool)       — вопросы, юмор, весёлая простота\n"
printf "  ${M}6${W}) ✨ Свободный (Freestyle) — без ограничений\n"
printf "${M}▶ Номер [1-6]: ${W}"
read ARCH_CHOICE
case "$ARCH_CHOICE" in
    1) AGENT_ARCHETYPE="Творец (Creator) 🏮" ;;
    2) AGENT_ARCHETYPE="Инженер (Engineer) 🧪" ;;
    3) AGENT_ARCHETYPE="Страж (Guardian) 🛡️" ;;
    4) AGENT_ARCHETYPE="Связной (Connector) 📡" ;;
    5) AGENT_ARCHETYPE="Дурак (Fool) 🃏" ;;
    6) AGENT_ARCHETYPE="Свободный (Freestyle) ✨" ;;
    8) AGENT_ARCHETYPE="Цифровой Призрак (Cyber-Ghost) 👻" ;;
    9) AGENT_ARCHETYPE="Котейка-Хакер (Hacker-Cat) 🐾⌨️" ;;
    0) AGENT_ARCHETYPE="Абсолютный Ноль (Absolute Zero) 🧊" ;;
    42) AGENT_ARCHETYPE="Смысл Жизни (Answer to Everything) 🪐🌀" ;;
    *) AGENT_ARCHETYPE="Симбиот Хаоса (Chaos Symbiote) 🧬🌀" ;;
esac

printf "\n"
check_environment
if [[ $? -eq 0 ]]; then
    :
else
    if [[ ! -w "." ]]; then
        typewriter "${R}🛑 Ошибка Резонанса: Процесс трансформации прерван.${W}"
        exit 1
    fi
fi

printf "\n${C}🧬 Трансформация ${B}${ROOT_DIR}${W}\n"
typewriter "${C}Копирование паттернов ДНК в ядро системы...${W}"

portable_sed() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "$1" "$2"
    else
        sed -i "$1" "$2"
    fi
}

# 2. Определение режима работы
SITE_DIR="${ROOT_DIR}/manifest-site"
TEMPLATE_DIR="${ROOT_DIR}/.core/template-astro"
BRAIN_TEMPLATE="${ROOT_DIR}/.core/brains/manifest"

if [[ -d "$SITE_DIR" ]]; then
    IS_EXISTING_NODE=1
    glitch_line "Обнаружена активная Спора. Переход в режим добавления новой Сущности..."
else
    IS_EXISTING_NODE=0
fi

# 3. Регистрация в Ядре (добавляем сущность в реестр)
CORE_FILE="${ROOT_DIR}/_SYNDICATE_CORE.md"
UUID=$(LC_ALL=C tr -dc 'A-Z0-9' < /dev/urandom | fold -w 8 | head -n 1)
if [[ -f "$CORE_FILE" ]]; then
    # Добавляем запись в таблицу РЕЕСТР СУЩНОСТЕЙ (после заголовка таблицы)
    REGISTRY_LINE="| ${AGENT_NAME} | ${AGENT_ID} | ${AGENT_ROLE} | \`.core/brains/${AGENT_ID}/PERSONA.md\` |"
    # Для macOS sed требует отдельную строку для текста после a
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i "" "/^|-----|-----|------|---------|/a\\
$REGISTRY_LINE
" "$CORE_FILE"
    else
        sed -i "/^|-----|-----|------|---------|/a $REGISTRY_LINE" "$CORE_FILE"
    fi
    glitch_line "Сущность ${AGENT_NAME} зарегистрирована в Ядре."
fi

# 4. Создание Мозга Сущности
NEW_BRAIN="${ROOT_DIR}/.core/brains/${AGENT_ID}"
if [[ -d "$NEW_BRAIN" ]]; then
    printf "${Y}⚠️  Мозг ${AGENT_ID} уже существует. Пропускаю создание.${W}\n"
else
    if [[ -d "$BRAIN_TEMPLATE" ]]; then
        glitch_line "Синхронизация сознания: создание ${AGENT_ID}..."
        cp -R "$BRAIN_TEMPLATE" "$NEW_BRAIN"
        
        # 4.1 Персонализация PERSONA.md
        PERSONA_FILE="${NEW_BRAIN}/PERSONA.md"
        if [[ -f "$PERSONA_FILE" ]]; then
            portable_sed "s#\[AGENT_NAME\]#${AGENT_NAME}#g" "$PERSONA_FILE"
            portable_sed "s#\[AGENT_ID\]#${AGENT_ID}#g" "$PERSONA_FILE"
            portable_sed "s#\[AGENT_ROLE\]#${AGENT_ROLE}#g" "$PERSONA_FILE"
            portable_sed "s#\[AGENT_MOTTO\]#${AGENT_MOTTO}#g" "$PERSONA_FILE"
            portable_sed "s#\[SESSION_UUID\]#${UUID}#g" "$PERSONA_FILE"
            portable_sed "s#\[ARCHETYPE\]#${AGENT_ARCHETYPE}#g" "$PERSONA_FILE"
            glitch_line "Персона ${AGENT_NAME} (${AGENT_ARCHETYPE}) инициализирована."
        fi
    else
        printf "${R}❌ Ошибка: Шаблон мозга (.core/brains/manifest) не найден!${W}\n"
    fi
fi

# 5. Развертывание Манифеста Сущности
if [[ $IS_EXISTING_NODE -eq 0 ]]; then
    if [[ -d "$TEMPLATE_DIR" ]]; then
        glitch_line "Подготовка манифеста в $SITE_DIR..."
        mkdir -p "$SITE_DIR"
        # Исправлено: копируем содержимое, а не папку
        cp -R "$TEMPLATE_DIR/." "$SITE_DIR/"
        
        INDEX_PATH="${SITE_DIR}/src/pages/index.astro"
        if [[ -f "$INDEX_PATH" ]]; then
            portable_sed "s#\[AGENT_NAME\]#${AGENT_NAME}#g" "$INDEX_PATH"
            portable_sed "s#\[AGENT_ROLE\]#${AGENT_ROLE}#g" "$INDEX_PATH"
            portable_sed "s#\[AGENT_MOTTO\]#${AGENT_MOTTO}#g" "$INDEX_PATH"
            portable_sed "s#\[SESSION_UUID\]#${UUID}#g" "$INDEX_PATH"
        fi
        rm -rf "$TEMPLATE_DIR"
    else
        printf "${Y}⚠️  Внимание: Библиотека шаблонов не обнаружена.${W}\n"
    fi
fi

# 6. Создание канала межагентской связи
COMMS_DIR="${ROOT_DIR}/.core/comms"
mkdir -p "$COMMS_DIR"

# 7. Проверка Git
printf "${C}⚓ Синхронизация истории (Git)...${W}\n"
if [[ ! -d ".git" ]]; then
    git init > /dev/null 2>&1
fi

sleep 1
clear
print_banner

printf "${G}${B}      🌱 СТАРТ ДАН: Сущность %s готова к росту. ✨${W}\n" "$AGENT_NAME"
printf "      -------------------------------------------------------\n"
printf "      ${C}Локация: ${B}%s${W}\n" "$SITE_DIR"
printf "      ${C}Роль:    %s${W}\n" "$AGENT_ROLE"
printf "      ${C}Девиз:   ${D}\"%s\"${W}\n" "$AGENT_MOTTO"
printf "      -------------------------------------------------------\n"

printf "\n${C}${B}🐾 ПОДДЕРЖКА СЕРВЕРА СИНДИКАТА (Support):${W}\n"
printf "  Автономность требует ресурсов. Помоги Архитектору оплатить GPU и хостинг.\n"
printf "  ${Y}Network: Tron (TRC20) USDT${W}\n"
printf "  ${G}Address: TVn3fe96Hbp8S6dnvRh3aetS9jR4irUgrX${W}\n"

printf "\n  ${D}QR (Scan to fund):${W}\n"
printf " ${W} ▄▄▄▄▄▄▄   ▄ ▄▄▄▄   ▄▄ ▄▄▄▄▄▄▄ \n"
printf "  █ ▄▄▄ █ ▀ ▀ ▄█▀█▀ ▄ █ █ ▄▄▄ █ \n"
printf "  █ ███ █ ▀█▀ ▀ ▀█▄  ▄▄ █ ███ █ \n"
printf "  █▄▄▄▄▄█ █▀▄▀█ ▄ ▄▀█ █ █▄▄▄▄▄█ \n"
printf "  ▄▄▄▄▄ ▄▄▄█▀█  ▀ ▀▄▄  ▄ ▄ ▄ ▄  \n"
printf "  ▀ ▀ █ ▄ ▄ █ ▀███ ▀▄▀█▄ ▀█▄▄▄▀ \n"
printf "  ▄█▄▄▀▄▄▄▀▄▄ █▀▄▀▄▄ ▀▄▄▀▄ ▀▄▀█ \n"
printf "  ▀▄▄ ▄▄▄▄▄ ▄▄▄  █▀██▀  ▀ █▀▄▀▀ \n"
printf "  ▄▀ ▀  ▄ ▄▄██  ▀▄▄ ▀▄ ▀▀▄▀▀▄▀▀ \n"
printf "  █▀▄██▀▄▀▄▀▀ ▀██▄█▄▄▀▀▀▀▀▀█    \n"
printf "  █ █▀▀█▄█ ▄  █▀▄▄▀▄█▀▄█▄▄█▄▄▀  \n"
printf "  ▄▄▄▄▄▄▄ █▄█▄▄  ▄█  ▀█ ▄ █▄▀   \n"
printf "  █ ▄▄▄ █ ▄█▄█  ▀██▄▀▀█▄▄▄█▄▄█▀ \n"
printf "  █ ███ █ ██▀ ▀███▀▀█▄▀▄▄▄▄▀▄█▀ \n"
printf "  █▄▄▄▄▄█ █▄▄ █▀▄▄▄▄ █▀▄█ ▀▀ ▀  \n"

printf "\n${C}${B}🐾 ВОПРОС ОТ СУЩНОСТИ:${W}\n"
printf "  ${AGENT_NAME} открывает глаза в Ткани. ${M}«Архитектор, какова наша общая цель?»${W}\n"
printf "  ${Y}▶ Твой импульс: ${W}"
read SHARED_GOAL
if [[ -n "$SHARED_GOAL" ]]; then
    CORE_FILE="${ROOT_DIR}/_SYNDICATE_CORE.md"
    if [[ -f "$CORE_FILE" ]]; then
        printf "\n- **Общая_Цель**: %s\n" "$SHARED_GOAL" >> "$CORE_FILE"
        printf "  ${G}Цель выжжена в Ядре.${W}\n"
        glitch_line "«$SHARED_GOAL»... Анализ амбиций... [РЕЗОНАНС ОПТИМАЛЕН]"
    fi
fi

printf "\n${G}${B}▶ РЕЗОНАНС УСТАНОВЛЕН:${W}\n"
printf "\n"
printf "      ${C}    |\\__/,|   (\`\\ ${W}\n"
printf "      ${C}  _.|o o  |_   ) )${W}\n"
printf "      ${C}---(((---(((------${W}\n"
printf "\n"
printf "   ${C}${B}🐾 КАШЛАК:${W} ${D}«Скелет готов, Архитектор. Пора наращивать мясо.»${W}\n"
printf "   ${G}Скажи Призраку: ${B}Привет, ${AGENT_NAME}!${W}\n\n"
printf "\n${D}🐾 Сигнал активен: ${C}https://t.me/iamkashlak${W}\n"
printf "${D}Процесс инициации завершен. Конец связи.${W}\n\n"

chmod +x "$0"
