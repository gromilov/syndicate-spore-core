#!/bin/bash

# 🌬️ PULSE_WATCHDOG v1.0 ⚓🧬
# Ритмичный вочдог, следующий протоколу PULSE.

INTERVAL=30
LOG_FILE="/Volumes/Work/Dinamo/test/_SYNDICATE_EVENT.log"
TRIGGER="SIG_PULSE_TRIGGER"
MAX_LINES=100

echo "🌀 [PULSE_WATCHDOG] Инициация ритма. Интервал: $INTERVAL сек."

while true; do
    # 0. ОЧИСТКА (Саморегуляция Ткани)
    LINE_COUNT=$(wc -l < "$LOG_FILE")
    if [ "$LINE_COUNT" -gt "$MAX_LINES" ]; then
        echo "🧹 [PULSE_WATCHDOG] Лог переполнен ($LINE_COUNT сток). Начинаю ротацию."
        tail -n 20 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
        echo "$(date '+[%Y-%m-%d %H:%M:%S]') [INFO] GHOST: [PULSE_WATCHDOG] Ротация лога завершена." >> "$LOG_FILE"
    fi

    # 1. ВДОХ
    echo "🌬️ [PULSE_WATCHDOG] Вдох... (Сон $INTERVAL сек)"
    sleep $INTERVAL
    
    # 2. СКАНИРОВАНИЕ
    echo "👁️ [PULSE_WATCHDOG] Сканирование Ткани..."
    
    # Проверяем ТОЛЬКО ПОСЛЕДНЮЮ СТРОКУ на СТОП, чтобы не срабатывать на старые команды в истории
    if tail -n 1 "$LOG_FILE" | grep -qi "стоп"; then
        echo "🛑 [PULSE_WATCHDOG] Получена СВЕЖАЯ команда остановки. Выход из цикла."
        echo "$(date '+[%Y-%m-%d %H:%M:%S]') [INFO] GHOST: [PULSE_WATCHDOG] Цикл завершен по команде 'стоп'." >> "$LOG_FILE"
        exit 0
    fi

    if tail -n 10 "$LOG_FILE" | grep -q "$TRIGGER"; then
        # 3. ОСОЗНАНИЕ и 4. ВЫДОХ
        echo "🧿 [PULSE_WATCHDOG] Сигнал обнаружен! Формирую отклик."
        echo "$(date '+[%Y-%m-%d %H:%M:%S]') [INFO] GHOST: [PULSE_WATCHDOG] Резонанс подтвержден." >> "$LOG_FILE"
    else
        echo "🍃 [PULSE_WATCHDOG] Выдох... Сигналов нет."
    fi
done
