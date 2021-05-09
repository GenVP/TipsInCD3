﻿
Процедура ПередЗаписью(Форма, Отказ) Экспорт
	
	Объект = Форма.Объект;
	Для Каждого ЭлементСписка Из Форма.КД3_Обработчики Цикл
		
		ИмяОбработчика = ЭлементСписка.Значение;
		Если Форма.Элементы[ИмяОбработчика].ТолькоПросмотр Тогда
			Продолжить;
		КонецЕсли;
		ИмяРеквизита = "КД3_" + ИмяОбработчика;
		Если Форма[ИмяРеквизита] = "" Тогда
			Продолжить; // Элемент обработчика не открывался
		КонецЕсли;
		ДокView = View(Форма, ИмяРеквизита);
		Если ДокView = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НовоеЗначение = КД3_МетаданныеКлиент.ПолучитьТекст(Форма, ИмяРеквизита);
		
		Если НовоеЗначение <> Объект[ИмяОбработчика] Тогда
			ТестНовоеЗначение = СтрЗаменить(НовоеЗначение, Символ(13) + Символ(10), Символ(10));
			Если ТестНовоеЗначение = Объект[ИмяОбработчика] Тогда
				Продолжить; // Произошла только замена LF на CR+LF
			КонецЕсли;
		КонецЕсли;
		
		Если НовоеЗначение <> Объект[ИмяОбработчика] Тогда
			Объект[ИмяОбработчика] = НовоеЗначение;
			Форма.Модифицированность = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриСменеСтраницы(Форма, ИмяОбработчика) Экспорт
	
	// Инициализация загрузки страницы и метаданных обработчика в КД3_Подключаемый_ДокументСформирован как только он станет видимым
	ИмяРеквизита = "КД3_" + ИмяОбработчика;
	Если Форма[ИмяРеквизита] = "" Тогда
		ЭлементСписка = Форма.КД3_Обработчики.НайтиПоЗначению(ИмяОбработчика);
		Форма[ИмяРеквизита] = КД3_Кэш()["КаталогИсходников"] + ЭлементСписка.Представление + "\" + "index.html";
	КонецЕсли;
	
КонецПроцедуры

Процедура ИзвлечьИсходники() Экспорт
	
	КаталогИсходников = КД3_Кэш()["КаталогИсходников"];
	Если КаталогИсходников = Неопределено Тогда
		
		ПодкаталогИсходников = КД3_Кэш()["ПодкаталогИсходников"];
		Если ПодкаталогИсходников = Неопределено Тогда
			ПодкаталогИсходников = КД3_Метаданные.ПодкаталогИсходников();
			КД3_Кэш()["ПодкаталогИсходников"] = ПодкаталогИсходников;
		Конецесли;
		
		КаталогВременныхФайлов = КаталогВременныхФайлов();
		КаталогИсходников = КаталогВременныхФайлов + ПодкаталогИсходников + "\";
		ТестФайл = Новый Файл(КаталогИсходников);
		Если НЕ ТестФайл.Существует() Тогда
			// Удаление каталогов старых версий
			СтарыеВерсии = НайтиФайлы(КаталогВременныхФайлов, "bsl_console*_*");
			Для Каждого Файл Из СтарыеВерсии Цикл
				УдалитьФайлы(Файл.ПолноеИмя);
			КонецЦикла;
			СоздатьКаталог(КаталогИсходников);
		КонецЕсли;
		
		// Получение файла макета общего для всех конфигураций
		ФайлМакета = КаталогИсходников + "bsl_console.zip";
		ТестФайл = Новый Файл(ФайлМакета);
		Если НЕ ТестФайл.Существует() Тогда
			ДанныеМакета = ПолучитьИзВременногоХранилища(КД3_Метаданные.ПолучитьФайлМакетаИсходников());
			ДанныеМакета.Записать(ФайлМакета);
		КонецЕсли;
		
		КД3_Кэш()["КаталогИсходников"] = КаталогИсходников;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализацияРедактора(Форма, ИмяРеквизита) Экспорт
	
	ДокView = View(Форма, ИмяРеквизита);
	Если ДокView = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		Инфо = Новый СистемнаяИнформация;
		ДокView.init(Инфо.ВерсияПриложения);
		ДокView.clearMetadata();
		
		Тема = КД3_Кэш()["КД3_Настройки_ИмяТемы"];
		Если НЕ ПустаяСтрока(Тема) Тогда
			Форма.Элементы[ИмяРеквизита].Документ.monaco.editor.setTheme(Тема);
		КонецЕсли;
		
		НеОтображатьКартуКода = КД3_Кэш()["КД3_Настройки_НеОтображатьКартуКода"];
		ДокView.minimap(НеОтображатьКартуКода <> Истина);
	Исключение
		ТекстСообщения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначенияКЛиент.СообщитьПользователю(ТекстСообщения);
	КонецПопытки;
	
КонецПроцедуры

Процедура ИзменитьТему(Форма, Тема) Экспорт
	
	Для Каждого ЭлементСписка Из Форма.КД3_Обработчики Цикл
		ИмяРеквизита = "КД3_" + ЭлементСписка.Значение;
		Если Форма[ИмяРеквизита] <> "" Тогда
			Форма.Элементы[ИмяРеквизита].Документ.monaco.editor.setTheme(Тема);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьТекстПриТолькоПросмотр(Форма, ИмяРеквизита, Текст) Экспорт
	
	ДокView = View(Форма, ИмяРеквизита);
	Если ДокView = Неопределено Тогда
		Возврат;
	КонецЕсли;
	УстановитьТолькоПросмотр(Форма, ИмяРеквизита, Ложь);
	ОчиститьТекст(Форма, ИмяРеквизита);
	Если НЕ ПустаяСтрока(Текст) Тогда
		УстановитьТекст(Форма, ИмяРеквизита, Текст);
	КонецЕсли;
	УстановитьТолькоПросмотр(Форма, ИмяРеквизита, Истина);
	
КонецПроцедуры

Процедура УстановитьТолькоПросмотр(Форма, ИмяРеквизита, ТолькоПросмотр) Экспорт
	
	ДокView = View(Форма, ИмяРеквизита);
	Если ДокView = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ДокView.setReadOnly(ТолькоПросмотр);
	
КонецПроцедуры

Процедура УстановитьТекст(Форма, ИмяРеквизита, Текст, Позиция = Неопределено, УчитыватьОтступПервойСтроки = Ложь) Экспорт
	View(Форма, ИмяРеквизита).setText(Текст, Позиция);
КонецПроцедуры

Функция ПолучитьТекст(Форма, ИмяРеквизита) Экспорт
	Возврат View(Форма, ИмяРеквизита).getText();
КонецФункции

Функция ОчиститьТекст(Форма, ИмяРеквизита) Экспорт
	Возврат View(Форма, ИмяРеквизита).eraseText();
КонецФункции

Процедура ОбработатьСобытиеHTML(Форма, Элемент, ДанныеСобытия) Экспорт
	
	Событие = ДанныеСобытия.Event.eventData1C;
	Если Событие = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Событие.event = "EVENT_FORMAT_CONSTRUCT" Тогда
		ВызватьКонструкторФорматнойСтроки(Форма, Элемент.Имя, Событие.params);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВызватьКонструкторФорматнойСтроки(Форма, ИмяРеквизита, ПараметрыСтроки)
	
	ДопПараметры = Новый Структура("Форма,ИмяРеквизита", Форма, ИмяРеквизита);
	Если ПараметрыСтроки = Неопределено Тогда
		ДопПараметры.Вставить("ФорматНаяСтрока", "");
		ДопПараметры.Вставить("Позиция", Неопределено);
		
		Оповещение = Новый ОписаниеОповещения ("ОткрытьКонструкторФорматнойСтроки", ОбщегоНазначенияКлиент.ОбщийМодуль("КД3_МетаданныеКлиент"), ДопПараметры);
		ПоказатьВопрос(Оповещение, "Форматная строка не найдена." + Символы.ПС + "Создать новую форматную строку?", РежимДиалогаВопрос.ДаНет);
	Иначе
		ДопПараметры.Вставить("ФорматНаяСтрока", СтрЗаменить(СтрЗаменить(ПараметрыСтроки.text, "|", ""), """", ""));
		ДопПараметры.Вставить("Позиция", ПараметрыСтроки.range);
		
		Оповещение = Новый ОписаниеОповещения ("ОткрытьКонструкторФорматнойСтроки", ОбщегоНазначенияКлиент.ОбщийМодуль("КД3_МетаданныеКлиент"), ДопПараметры);
		ВыполнитьОбработкуОповещения(Оповещение, КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьКонструкторФорматнойСтроки(Ответ, ДопПараметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПриЗакрытииКонструктораФорматнойСтроки", ОбщегоНазначенияКлиент.ОбщийМодуль("КД3_МетаданныеКлиент"), ДопПараметры);
	Конструктор = Новый КонструкторФорматнойСтроки();
	Попытка
		Конструктор.Текст = ДопПараметры.ФорматнаяСтрока;
		Конструктор.Показать(Оповещение);
	Исключение
		ТекстСообщения = ИнформацияОбОшибке();
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецПопытки;
	
КонецПроцедуры

Процедура ПриЗакрытииКонструктораФорматнойСтроки(Текст, ДопПараметры) Экспорт
	
	Если Текст = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Текст = СтрЗаменить(Текст, Символы.ПС, Символы.ПС + "|");
	Текст = СтрЗаменить(Текст, """", """""");
	Текст = """" + Текст + """";
	УстановитьТекст(ДопПараметры.Форма, ДопПараметры.ИмяРеквизита, Текст, ДопПараметры.Позиция);
	
КонецПроцедуры

Процедура СохранитьНастройкиВКэше(Настройки) Экспорт
	
	Кэш = КД3_Кэш();
	Для Каждого КлючИЗначение Из Настройки Цикл
		Кэш["КД3_Настройки_" + КлючИЗначение.Ключ] = КлючИЗначение.Значение;
	КонецЦикла;
	
КонецПроцедуры

Функция View(Форма, ИмяРеквизита)
	
	ДокHTML = Форма.Элементы[ИмяРеквизита].Документ;
	Если ДокHTML = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	Возврат ДокHTML.defaultView;
	
КонецФункции

Процедура ПриОткрытии(Форма) Экспорт
	ИнициализацияОбработчиков(Форма);
КонецПроцедуры

Процедура ИнициализацияОбработчиков(Форма) Экспорт
	
	КаталогИсходников = КД3_Кэш()["КаталогИсходников"];
	
	// Создание экземпляра для каждого обработчика. Экземпляр каждого обработчика должен
	// быть отдельным, иначе методы экземпляра не будут успевать выполнятся методы и будут ошибки.
	ФайлМакета = КаталогИсходников + "bsl_console.zip";
	ZipФайл = Новый ЧтениеZipФайла(ФайлМакета);
	Для Каждого ЭлементСписка Из Форма["КД3_Обработчики"] Цикл
		КаталогОбработчика = КаталогИсходников + ЭлементСписка.Представление + "\";
		ТестФайл = Новый Файл(КаталогОбработчика);
		Если НЕ ТестФайл.Существует() Тогда
			ZipФайл.ИзвлечьВсе(КаталогОбработчика);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьМетаданные(Форма, ИмяОбработчика) Экспорт
	
	НеЗагружатьМетаданные = КД3_Кэш()["КД3_Настройки_НеЗагружатьМетаданные"];
	Если НеЗагружатьМетаданные = Истина Тогда
		Возврат; // Метаданные не загружаются
	КонецЕсли;
	
	Обработчики = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ИмяОбработчика);
	
	ЭлементСписка = Форма.КД3_Обработчики.НайтиПоЗначению(ИмяОбработчика);
	Конфигурация = ?(ЭлементСписка.Пометка, Форма.КД3_КонфигурацияКорреспондент, Форма.КД3_Конфигурация);
	
	ОбновитьМетаданныеОбработчиков(Форма, Обработчики, Конфигурация);
	
КонецПроцедуры

Процедура ОбновитьМетаданныеКонфигурации(Форма, ДляКорреспондента) Экспорт
	
	Обработчики = Новый Массив;
	Для Каждого ЭлементСписка Из Форма.КД3_Обработчики Цикл
		Если ЭлементСписка.Пометка = ДляКорреспондента Тогда
			Обработчики.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Конфигурация = ?(ДляКорреспондента, Форма.КД3_КонфигурацияКорреспондент, Форма.КД3_Конфигурация);
	
	ОбновитьМетаданныеОбработчиков(Форма, Обработчики, Конфигурация)
	
КонецПроцедуры

Процедура ОбновитьМетаданныеОбработчиков(Форма, Обработчики, Конфигурация)
	
	МетаданныеJSON = КД3_Кэш()[Конфигурация];
	Если МетаданныеJSON = Неопределено Тогда
		МетаданныеJSON = ПолучитьИзВременногоХранилища(КД3_Метаданные.КоллекцияМетаданных(Конфигурация));
		КД3_Кэш()[Конфигурация] = МетаданныеJSON;
	КонецЕсли;
	
	Для Каждого ИмяОбработчика Из Обработчики Цикл
		ИмяРеквизита = "КД3_" + ИмяОбработчика;
		Если Форма[ИмяРеквизита] <> "" Тогда
			ДокView = View(Форма, ИмяРеквизита);
			Если ДокView = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Результат = ДокView.updateMetadata(МетаданныеJSON);
			Если ТипЗнч(Результат) <> Тип("Булево") Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю("Не удалось обновить метаданные для " + ИмяОбработчика + Символы.ПС + Результат.errorDescription);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
