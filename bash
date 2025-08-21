import random
from aiogram import Bot, Dispatcher, executor, types

API_TOKEN = "7234640506: AAEH14dmMKJk0ajLFqjaQ1g_nf
KkfuwyP34"

bot = Bot(token=API_TOKEN)
dp = Dispatcher(bot)

# Храним состояние игры для каждого пользователя
games = {}

# Главное меню
def get_main_keyboard():
    keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
    keyboard.add("😂 Шутка", "🤔 Факт")
    keyboard.add("🎲 Кубик", "✊✋✌️ Игра")
    keyboard.add("🔢 Угадай число")
    return keyboard

# Меню для игры RPS
def get_rps_keyboard():
    keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
    keyboard.add("✊ Камень", "✋ Бумага", "✌️ Ножницы")
    keyboard.add("⬅️ Назад")
    return keyboard

# /start
@dp.message_handler(commands=["start"])
async def start(message: types.Message):
    await message.answer(
        "Привет! 🎉 Я твой развлекательный бот.\n"
        "Жми кнопки ниже 👇",
        reply_markup=get_main_keyboard()
    )

# Шутка
@dp.message_handler(lambda m: m.text == "😂 Шутка")
async def send_joke(message: types.Message):
    jokes = [
        "Почему компьютер всегда голодный? Потому что он постоянно ест байты! 💻",
        "Что сказал ноль восьмёрке? Классный у тебя ремень! 😆",
        "Программисты не тонут — они просто уходят в оффлайн. 🌊",
    ]
    await message.answer(random.choice(jokes))

# Факт
@dp.message_handler(lambda m: m.text == "🤔 Факт")
async def send_fact(message: types.Message):
    facts = [
        "Мёд никогда не портится. Археологи находили его в гробницах Египта! 🍯",
        "Осьминоги имеют три сердца 🐙",
        "У слонов есть «похоронные обряды» — они оплакивают умерших. 🐘",
    ]
    await message.answer(random.choice(facts))

# Кубик
@dp.message_handler(lambda m: m.text == "🎲 Кубик")
async def send_dice(message: types.Message):
    await bot.send_dice(message.chat.id, emoji="🎲")

# Игра RPS
@dp.message_handler(lambda m: m.text == "✊✋✌️ Игра")
async def start_rps(message: types.Message):
    await message.answer("Выбирай: Камень, Бумага или Ножницы ✊✋✌️", reply_markup=get_rps_keyboard())

@dp.message_handler(lambda m: m.text in ["✊ Камень", "✋ Бумага", "✌️ Ножницы"])
async def play_rps(message: types.Message):
    user_choice = message.text
    bot_choice = random.choice(["✊ Камень", "✋ Бумага", "✌️ Ножницы"])

    if user_choice == bot_choice:
        result = "Ничья 😅"
    elif (
        (user_choice == "✊ Камень" and bot_choice == "✌️ Ножницы") or
        (user_choice == "✋ Бумага" and bot_choice == "✊ Камень") or
        (user_choice == "✌️ Ножницы" and bot_choice == "✋ Бумага")
    ):
        result = "Ты выиграл! 🎉"
    else:
        result = "Я выиграл! 🤖"

    await message.answer(f"Ты выбрал: {user_choice}\nЯ выбрал: {bot_choice}\n\n{result}")

# Назад
@dp.message_handler(lambda m: m.text == "⬅️ Назад")
async def back_to_menu(message: types.Message):
    await message.answer("Возвращаемся в главное меню 👇", reply_markup=get_main_keyboard())

# Угадай число
@dp.message_handler(lambda m: m.text == "🔢 Угадай число")
async def guess_number_start(message: types.Message):
    games[message.from_user.id] = random.randint(1, 10)
    await message.answer("Я загадал число от 1 до 10 🔮 Попробуй угадать!")

@dp.message_handler(lambda m: m.from_user.id in games)
async def guess_number(message: types.Message):
    try:
        user_guess = int(message.text)
    except ValueError:
        await message.answer("Введи число от 1 до 10 😉")
        return

    secret = games[message.from_user.id]

    if user_guess == secret:
        await message.answer(f"🎉 Правильно! Я загадал {secret}.\nДавай сыграем ещё раз или выбери другое в меню 👇")
        del games[message.from_user.id]
    elif user_guess < secret:
        await message.answer("Моё число больше 🔼 Попробуй ещё раз!")
    else:
        await message.answer("Моё число меньше 🔽 Попробуй ещё раз!")

if __name__ == "__main__":
    executor.start_polling(dp, skip_updates=True)
