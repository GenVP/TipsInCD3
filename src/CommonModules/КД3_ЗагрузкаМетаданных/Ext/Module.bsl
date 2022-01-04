﻿
Процедура ОбработатьГруппуОбщихМодулей(ОбщиеПеременные, ЗагружатьМетодыНеГлобальныхМодулей = Ложь) Экспорт
	
	Разделитель = ПолучитьРазделительПутиСервера();
	
	Если ОбщиеПеременные.ИсточникДанных = 0 Тогда
		ВложенныеФайлы = НайтиПомещенныеФайлыПоМаске(ОбщиеПеременные.ПомещенныеФайлы, Разделитель + "CommonModules" + Разделитель, ".xml", ОбщиеПеременные);
	Иначе
		ВложенныеФайлы = НайтиПомещенныеФайлыПоМаске(ОбщиеПеременные.ПомещенныеФайлы, Разделитель + "src" + Разделитель + "CommonModules" + Разделитель, ".mdo", ОбщиеПеременные);
	КонецЕсли;
	Если ВложенныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеМетаданных = КоллекцияОбъектов(ОбщиеПеременные, "commonModules.items");
	ОписаниеМетаданных.Вставить("data", Новый Структура);
	Для Каждого ВложенныйФайл Из ВложенныеФайлы Цикл
		
		СвойстваМодуля = ПрочитатьСвойстваОбъекта(ВложенныйФайл.ТекущееИмяФайла, "Name,Global");
		
		Если СвойстваМодуля.Global <> "true" Тогда
			ОписаниеМетаданных.data.Вставить(СвойстваМодуля.Name, Новый Структура);
			Если ЗагружатьМетодыНеГлобальныхМодулей Тогда
				ДанныеМодуля = КоллекцияОбъектов(ОбщиеПеременные, "module." + СвойстваМодуля.Name);
				ДанныеМодуля.path = "commonModules.items." + СвойстваМодуля.Name;
			Иначе
				ДанныеМодуля = Неопределено;
			КонецЕсли;
			
		ИначеЕсли ОбщиеПеременные.КД3_ЗагружатьМетодыМодулей Тогда
			// Добавление методов глобального модуля
			ДанныеМодуля = КоллекцияОбъектов(ОбщиеПеременные, "globalfunctions");
		КонецЕсли;
		
		Если ДанныеМодуля <> Неопределено Тогда
			Если ОбщиеПеременные.ИсточникДанных = 0 Тогда
				ФайлТекста = НайтиПомещенныеФайлыПоМаске(ОбщиеПеременные.ПомещенныеФайлы, Разделитель + "CommonModules" + Разделитель +
					СвойстваМодуля.Name + Разделитель + "Ext" + Разделитель, "Module.bsl", ОбщиеПеременные);
			Иначе
				ФайлТекста = НайтиПомещенныеФайлыПоМаске(ОбщиеПеременные.ПомещенныеФайлы, Разделитель + "src" + Разделитель + "CommonModules" + Разделитель +
					СвойстваМодуля.Name + Разделитель, "Module.bsl", ОбщиеПеременные);
			КонецЕсли;
			Если ФайлТекста.Количество() = 1 Тогда
				ЗаполнитьМетодыМодуля(ДанныеМодуля, ФайлТекста[0].ТекущееИмяФайла, ОбщиеПеременные.КД3_Вычислитель);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ОписаниеМетаданных.count = ОписаниеМетаданных.data.Количество();
	
КонецПроцедуры

Функция ОбработатьГруппуОбъектов(ПараметрыЗагрузки, КлючКоллекции) Экспорт
	
	СтрокаТипа = КД3_МетаданныеПовтИсп.ВсеКорневыеТипы().Найти(КлючКоллекции, "Мн");
	ИмяКоллекции = СтрокаТипа.console;
	
	Разделитель = ПолучитьРазделительПутиСервера();
	ОписаниеКоллекции = Новый Структура;
	
	ОписаниеМетаданных = Новый Структура;
	ОписаниеМетаданных.Вставить("path", ИмяКоллекции + ".items");
	ОписаниеМетаданных.Вставить("data", ОписаниеКоллекции);
	
	Если ПараметрыЗагрузки.ИсточникДанных = 0 Тогда
		ВложенныеФайлы = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + СтрокаТипа.МнEng + Разделитель, ".xml", ПараметрыЗагрузки);
	Иначе
		ВложенныеФайлы = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + СтрокаТипа.МнEng + Разделитель, ".mdo", ПараметрыЗагрузки);
	КонецЕсли;
	Если ВложенныеФайлы.Количество() = 0 Тогда
		Возврат ОписаниеМетаданных;
	КонецЕсли;
	
	Для Каждого ВложенныйФайл Из ВложенныеФайлы Цикл
		ФайлОбъекта = Новый Файл(ВложенныйФайл.ТекущееИмяФайла);
		ОписаниеКоллекции.Вставить(ФайлОбъекта.ИмяБезРасширения, Новый Структура);
	КонецЦикла;
	ОписаниеМетаданных.Вставить("count", ОписаниеКоллекции.Количество());
	
	Возврат ОписаниеМетаданных;
	
КонецФункции

Функция ОбработатьОбъект(ПараметрыЗагрузки, КлючКоллекции, ИмяОбъекта) Экспорт
	
	СтрокаТипа = КД3_МетаданныеПовтИсп.ВсеКорневыеТипы().Найти(КлючКоллекции, "Мн");
	ИмяКоллекции = СтрокаТипа.console;
	
	Разделитель = ПолучитьРазделительПутиСервера();
	
	Если ПараметрыЗагрузки.ИсточникДанных = 0 Тогда
		ВложенныеФайлы = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + СтрокаТипа.МнEng + Разделитель, ИмяОбъекта + ".xml", ПараметрыЗагрузки);
	Иначе
		ВложенныеФайлы = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + СтрокаТипа.МнEng + Разделитель, ИмяОбъекта + ".mdo", ПараметрыЗагрузки);
	КонецЕсли;
	Если ВложенныеФайлы.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ВложенныеФайлы[0].ТекущееИмяФайла);
	
	ИмяОбъектаИзФайла = ИмяОбъекта;
	СтруктураОбъекта = ПрочитатьСведенияОбОбъекте(ЧтениеXML, ПараметрыЗагрузки, ИмяОбъектаИзФайла);
	
	ОписаниеМетаданных = Новый Структура;
	ОписаниеМетаданных.Вставить("path", СтрШаблон("%1.items.%2", ИмяКоллекции, ИмяОбъектаИзФайла));
	ОписаниеМетаданных.Вставить("data", СтруктураОбъекта);
	ОписаниеМетаданных.Вставить("count", 1);
	
	Возврат ОписаниеМетаданных;
	
КонецФункции

Функция ЗагрузитьМодульОбъекта(ОбщиеПеременные, Конфигурация, ВидМодуля, КорневойТип, ИмяОбъекта) Экспорт
	
	СтрокаТипа = КД3_МетаданныеПовтИсп.ВсеКорневыеТипы().Найти(КорневойТип, "Мн");
	ИмяКоллекции = СтрокаТипа.console;
	
	Разделитель = ПолучитьРазделительПутиСервера();
	
	Если ОбщиеПеременные.ИсточникДанных = 0 Тогда
		ФайлТекста = НайтиПомещенныеФайлыПоМаске(ОбщиеПеременные.ПомещенныеФайлы, Разделитель + СтрокаТипа.МнEng + Разделитель +
			ИмяОбъекта + Разделитель + "Ext" + Разделитель, ?(ВидМодуля = "module", "", ВидМодуля) + "Module.bsl", ОбщиеПеременные);
	Иначе
		ФайлТекста = НайтиПомещенныеФайлыПоМаске(ОбщиеПеременные.ПомещенныеФайлы, Разделитель + "src" + Разделитель + СтрокаТипа.МнEng + Разделитель +
			ИмяОбъекта + Разделитель, ?(ВидМодуля = "module", "", ВидМодуля) + "Module.bsl", ОбщиеПеременные);
	КонецЕсли;
	Если ФайлТекста.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// Получение реального имени объекта
	Если ОбщиеПеременные.ИсточникДанных = 0 Тогда
		ФайлОбъекта = НайтиПомещенныеФайлыПоМаске(ОбщиеПеременные.ПомещенныеФайлы, Разделитель + СтрокаТипа.МнEng + Разделитель, ИмяОбъекта + ".xml", ОбщиеПеременные);
	Иначе
		ФайлОбъекта = НайтиПомещенныеФайлыПоМаске(ОбщиеПеременные.ПомещенныеФайлы, Разделитель + "src" + Разделитель + СтрокаТипа.МнEng + Разделитель, ИмяОбъекта + ".mdo", ОбщиеПеременные);
	КонецЕсли;
	Если ФайлОбъекта.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	ТекстФайл = Новый Файл(ФайлОбъекта[0].ИсходноеИмяФайла);
	ИмяОбъектаИзФайла = ТекстФайл.ИмяБезРасширения;
	
	ОписаниеМетаданных = Новый Структура;
	ОписаниеМетаданных.Вставить("module", Новый Структура);
	ОписаниеМетаданных.Вставить("count", 0);
	Если ВидМодуля = "module" Тогда
		ОписаниеМетаданных.Вставить("path", СтрШаблон("%1.items.%2", ИмяКоллекции, ИмяОбъектаИзФайла));
	Иначе
		ОписаниеМетаданных.Вставить("path", СтрШаблон("%1.items.%2.%3", ИмяКоллекции, ИмяОбъектаИзФайла, НРЕг(ВидМодуля)));
	КонецЕсли;
	
	ЗаполнитьМетодыМодуля(ОписаниеМетаданных, ФайлТекста[0].ТекущееИмяФайла, ОбщиеПеременные.КД3_Вычислитель);
	
	Возврат ОписаниеМетаданных;
	
КонецФункции

Функция КоллекцияОбъектов(ОбщиеПеременные, ИмяКоллекции) Экспорт
	
	КД3_Конфигурация = Неопределено;
	Если НЕ ОбщиеПеременные.Свойство("КД3_Конфигурация", КД3_Конфигурация) Тогда
		КД3_Конфигурация = Новый Соответствие;
		ОбщиеПеременные.Вставить("КД3_Конфигурация", КД3_Конфигурация);
	КонецЕсли;
	
	КоллекцияОбъекта = КД3_Конфигурация[ИмяКоллекции];
	Если КоллекцияОбъекта = Неопределено Тогда
		КоллекцияОбъекта = Новый Структура;
		КоллекцияОбъекта.Вставить("path", ИмяКоллекции);
		КоллекцияОбъекта.Вставить("count", 0);
		КД3_Конфигурация.Вставить(ИмяКоллекции, КоллекцияОбъекта);
	КонецЕсли;
	
	Возврат КоллекцияОбъекта;
	
КонецФункции

Процедура ЗаполнитьМетодыМодуля(ДанныеМодуля, ПолноеИмяФайла, КД3_Вычислитель)
	
	ЧтениеТекста = Новый ЧтениеТекста(ПолноеИмяФайла, "UTF-8",,, Ложь);
	ТекстМодуля = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();
	
	Выражение = "^(?<directive0>^&[А-Яа-я\w]*\s*)?\s*(?<comment>(?:^[^\n\S]*\/\/[^\r\n]*\n)*)\s*(?<directive1>^&[А-Яа-я\w]*\s*)?(?<type>процедура|функция)\s+(?<name>[А-Яа-я\w]+)\s*\((?<params>[^)]*)\)\s*(?<export>экспорт)";
	Совпадения = ВычислительНайтиСовпадения(КД3_Вычислитель, ТекстМодуля, Выражение, "Директива0,Описание,Директива1,Тип,Имя,Параметры,Экспорт");
	
	Если НЕ ДанныеМодуля.Свойство("module") Тогда
		ДанныеМодуля.Вставить("module", Новый Структура);
		ДанныеМодуля.Вставить("count", 0);
	КонецЕсли;
	
	Для Каждого Совпадение Из Совпадения Цикл
		ОписаниеМетода = Совпадение.Описание;
		ОписаниеПример = ВыделитьБлокОписания(КД3_Вычислитель, ОписаниеМетода, "Пример");
		ОписаниеВозвращаемоеЗначение = ВыделитьБлокОписания(КД3_Вычислитель, ОписаниеМетода, "Возвращаемое значение");
		ОписаниеПараметры = ВыделитьБлокОписания(КД3_Вычислитель, ОписаниеМетода, "Параметры");
		ОписаниеМетода = УдалитьСлешиИзКомментария(КД3_Вычислитель, ОписаниеМетода);
		
		СтруктураПараметров = Новый Структура;
		
		ЗаполнитьПараметрыМетодаПоЗаголовку(КД3_Вычислитель, СтруктураПараметров, Совпадение.Параметры);
		ЗаполнитьПараметрыМетодаПоОписанию(КД3_Вычислитель, СтруктураПараметров, ОписаниеПараметры);
		
		ДанныеМетода = Новый Структура;
		ДанныеМетода.Вставить("name", Совпадение.Имя);
		ДанныеМетода.Вставить("name_en", Совпадение.Имя);
		ДанныеМетода.Вставить("description", УдалитьСлешиИзКомментария(КД3_Вычислитель, Совпадение.Описание));
		ДанныеМетода.Вставить("detail", ОписаниеМетода);
		ДанныеМетода.Вставить("returns", "");
		ДанныеМетода.Вставить("signature", Новый Структура("default", Новый Структура));
		
		ДанныеМетода.signature.default.Вставить("СтрокаПараметров", "(" + Совпадение.Параметры + ")");
		ДанныеМетода.signature.default.Вставить("Параметры", СтруктураПараметров);
		
		ДанныеМодуля.module.Вставить(Совпадение.Имя, ДанныеМетода);
	КонецЦикла;
	
	ДанныеМодуля.count = ДанныеМодуля.module.Количество();
	
КонецПроцедуры

Функция НайтиПомещенныеФайлыПоМаске(ПомещенныеФайлы, ВложенныйКаталог, РасширениеФайла, ОбщиеПеременные) Экспорт
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("ИсходноеИмяФайла");
	Результат.Колонки.Добавить("ТекущееИмяФайла");
	
	ИсключитьВложенныеКаталоги = (СтрНайти(РасширениеФайла, "mdo") = 0);
	
	Если ПомещенныеФайлы = Неопределено Тогда
		// Прямой поиск в файлах
		Если НЕ СтрНачинаетсяС(ВложенныйКаталог, ПолучитьРазделительПутиСервера()) Тогда
			ВложенныйКаталог = ПолучитьРазделительПутиСервера() + ВложенныйКаталог;
		КонецЕсли;
		НайденныеФайлы = НайтиФайлы(ОбщиеПеременные.КаталогЗагрузки + ВложенныйКаталог, "*" + РасширениеФайла, НЕ ИсключитьВложенныеКаталоги);
		Для Каждого НайденныйФайл Из НайденныеФайлы Цикл
			НовСтрока = Результат.Добавить();
			НовСтрока.ИсходноеИмяФайла = НайденныйФайл.ПолноеИмя;
			НовСтрока.ТекущееИмяФайла = НайденныйФайл.ПолноеИмя;
		КонецЦикла;
	Иначе
		// Поиск в подготовленных файлах
		Для Каждого ТекФайл Из ПомещенныеФайлы Цикл
			Если ТекФайл.ЭтоРасширение <> ОбщиеПеременные.ЭтоРасширение Тогда
				Продолжить;
			ИначеЕсли ОбщиеПеременные.ЭтоРасширение Тогда
				ЭтоНаше = СтрНайти(ТекФайл.ПолноеИмя, ОбщиеПеременные.ПутьКФайламРасширения) > 0;
				Если НЕ ЭтоНаше Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			ПозицияКаталога = СтрНайти(ТекФайл.ПолноеИмя, ВложенныйКаталог);
			ПозицияРасширения = СтрНайти(ТекФайл.ПолноеИмя, РасширениеФайла);
			Если ПозицияКаталога > 0
				И ПозицияРасширения > 0 Тогда
				Если ИсключитьВложенныеКаталоги Тогда
					// Исключаем вариант с вложенными каталогами.
					ПозицияКонцаКаталога = ПозицияКаталога + СтрДлина(ВложенныйКаталог) + 1;
					КраткоеИмяФайла = Сред(ТекФайл.ПолноеИмя, ПозицияКонцаКаталога, ПозицияРасширения);
					ЭтоПодкаталог = СтрНайти(КраткоеИмяФайла, "/") > 0 Или СтрНайти(КраткоеИмяФайла, "\") > 0;
					Если ЭтоПодкаталог Тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
				НовСтрока = Результат.Добавить();
				НовСтрока.ИсходноеИмяФайла = ТекФайл.ПолноеИмя;
				НовСтрока.ТекущееИмяФайла = ТекФайл.Хранение;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат Результат;
КонецФункции

#Область Анализ_модуля

Функция ПодключитьВычислитель(ОбщиеПеременные = Неопределено) Экспорт
	
	КД3_Вычислитель = Неопределено;
	Если ОбщиеПеременные <> Неопределено И ОбщиеПеременные.Свойство("КД3_Вычислитель", КД3_Вычислитель) Тогда
		Возврат КД3_Вычислитель;
	КонецЕсли;
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	
	Если СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86 Тогда
		Платформа = "Lin";
		Разрядность = "32";
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
		Платформа = "Lin";
		Разрядность = "64";
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86 Тогда
		Платформа = "Win";
		Разрядность = "32";
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		Платформа = "Win";
		Разрядность = "64";
	Иначе
		ВызватьИсключение "Не поддерживаемый тип платформы";
	КонецЕсли;
	Местоположение = "ОбщийМакет.КД3_RegEx" + Платформа + Разрядность;
	
	Успешно = ПодключитьВнешнююКомпоненту(Местоположение, "ВычислительРегВыражений", ТипВнешнейКомпоненты.Native);
	КД3_Вычислитель = Новый("AddIn.ВычислительРегВыражений.RegEx");
	
	КД3_Вычислитель.IgnoreCase = Истина;
	КД3_Вычислитель.Global = Истина;
	КД3_Вычислитель.MultiLine = Истина;
	
	Если ОбщиеПеременные <> Неопределено Тогда
		ОбщиеПеременные.Вставить("КД3_Вычислитель", КД3_Вычислитель);
	КонецЕсли;
	
	Возврат КД3_Вычислитель;
	
КонецФункции

Функция ВычислительНайтиСовпадения(КД3_Вычислитель, Текст, Выражение, ИменаГрупп)
	
	МассивГрупп = СтрРазделить(ИменаГрупп, ",", Ложь);
	
	ТекстJSON = КД3_Вычислитель.MatchesJSON(Текст, Выражение);
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ТекстJSON);
	СовпаденияJSON = ПрочитатьJSON(ЧтениеJSON, Ложь);
	ЧтениеJSON.Закрыть();
	
	Совпадения = Новый Массив;
	Для Каждого СовпадениеJSON Из СовпаденияJSON Цикл
		Совпадение = Новый Структура;
		Если МассивГрупп.Количество() = 0 Тогда
			Совпадение.Вставить("Индекс", СовпадениеJSON.FirstIndex);
			Совпадение.Вставить("Текст", СовпадениеJSON.Value);
		Иначе
			Индекс = 0;
			Для Каждого ЗначениеГруппы Из СовпадениеJSON.SubMatches Цикл
				Совпадение.Вставить(МассивГрупп[Индекс], ЗначениеГруппы);
				Индекс = Индекс + 1;
			КонецЦикла;
		КонецЕсли;
		Совпадения.Добавить(Совпадение);
	КонецЦикла;
	
	Возврат Совпадения;
	
КонецФункции

Функция ВыделитьБлокОписания(КД3_Вычислитель, ОписаниеМетода, ИмяБлока)
	
	Если ПустаяСтрока(ОписаниеМетода) Тогда
		Возврат "";
	КонецЕсли;
	
	ИмяБлокаРег = СтрЗаменить(НРег(ИмяБлока), " ", "\s+");
	Выражение = СтрЗаменить("^\s*\/\/\s*ИмяБлока\s*[:][\s\S]*", "ИмяБлока", ИмяБлокаРег);
	
	Совпадения = ВычислительНайтиСовпадения( КД3_Вычислитель, ОписаниеМетода, Выражение, "");
	Если Совпадения.Количество() <> 1 Тогда
		Возврат "";
	КонецЕсли;
	
	ОписаниеМетода = Лев(ОписаниеМетода, Совпадения[0].Индекс);
	
	Возврат УдалитьСлешиИзКомментария(КД3_Вычислитель, Совпадения[0].Текст);
	
КонецФункции

Процедура ЗаполнитьПараметрыМетодаПоОписанию(КД3_Вычислитель, СтруктураПараметров, ОписаниеПараметры)
	
	Если СтруктураПараметров.Количество() = 0 ИЛИ ПустаяСтрока(ОписаниеПараметры) Тогда
		Возврат;
	КонецЕсли;
	
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Имя");
	ТЗ.Колонки.Добавить("Индекс");
	
	Для Каждого КлючИЗначение Из СтруктураПараметров Цикл
		Выражение = СтрЗаменить("^[\s]*Параметр\s*[-–]\s*\S*\s*[-–]", "Параметр", КлючИЗначение.Ключ);
		Совпадения = ВычислительНайтиСовпадения(КД3_Вычислитель, ОписаниеПараметры, Выражение, "");
		Если Совпадения.Количество() = 1 Тогда
			СтрокаТЗ = ТЗ.Добавить();
			СтрокаТЗ.Имя = КлючИЗначение.Ключ;
			СтрокаТЗ.Индекс = Совпадения[0].Индекс;
		КонецЕсли;
	КонецЦикла;
	ТЗ.Сортировать("Индекс");
	
	ИндексСтроки = 0;
	КоличествоСтрок = ТЗ.Количество();
	Пока ИндексСтроки < КоличествоСтрок Цикл
		СтрокаТЗ = ТЗ[ИндексСтроки];
		ИндексСтроки = ИндексСтроки + 1;
		Если ИндексСтроки = КоличествоСтрок Тогда
			ОписаниеПараметра = Сред(ОписаниеПараметры, СтрокаТЗ.Индекс);
		Иначе
			ОписаниеПараметра = Сред(ОписаниеПараметры, СтрокаТЗ.Индекс, ТЗ[ИндексСтроки].Индекс  - СтрокаТЗ.Индекс);
		КонецЕсли;
		СтруктураПараметров.Вставить(СтрокаТЗ.Имя, СокрЛ(ОписаниеПараметра));
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыМетодаПоЗаголовку(КД3_Вычислитель, СтруктураПараметров, СтрокаПараметров)
	
	Если СтрокаПараметров = Неопределено Тогда
		Возврат;
	КонецЕсли;
	//TODO: Обрабатывать возможные комментарии в параметрах методов в заголовке
	Выражение = "[знач]?([А-Яа-я\w]+)\s*(?:=\s*[^,]*)?,";
	Совпадения = ВычислительНайтиСовпадения(КД3_Вычислитель, СтрокаПараметров + ",", Выражение, "Имя");
	Для Каждого Совпадение Из Совпадения Цикл
		СтруктураПараметров.Вставить(Совпадение.Имя, "");
	КонецЦикла;
	
КонецПроцедуры

Функция УдалитьСлешиИзКомментария(КД3_Вычислитель, ТекстКомментария)
	Возврат КД3_Вычислитель.Заменить(ТекстКомментария, "(^\s*\/\/\s{0,2})", "");
КонецФункции

#КонецОбласти

#Область Чтение_файла_XML_или_EDT

Функция ПрочитатьСвойстваОбъекта(ПолноеИмяФайла, ИменаСвойств);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ПолноеИмяФайла);
	
	ЧтениеXML.Прочитать();
	Если ЭтоУзел(ЧтениеXML, "MetaDataObject") Тогда
		// Формат XML
		ЧтениеXML.Прочитать(); // MetaDataObject
		ЧтениеXML.Прочитать(); // Объект
	Иначе
		// Формат EDT
		ЧтениеXML.Прочитать(); // mdclass:Объект
	КонецЕсли;
	
	Возврат ПрочитатьСвойства(ЧтениеXML, ИменаСвойств, Истина);
	
КонецФункции

Функция ПрочитатьСведенияОбОбъекте(ЧтениеXML, ПараметрыЗагрузки, ИмяОбъекта)
	
	//TODO: Предопределенные
	//TODO: Общие реквизиты
	//TODO: Типы объектов
	
	ОписаниеРеквизитов = Новый Структура;
	ОписаниеРесурсов = Новый Структура;
	ОписаниеТабЧастей = Новый Структура;
	
	СтруктураОбъекта = Новый Структура;
	
	ЧтениеXML.Прочитать();
	Если ЭтоУзел(ЧтениеXML, "MetaDataObject") Тогда
		// Формат XML
		ЧтениеXML.Прочитать(); // MetaDataObject
		ЧтениеXML.Прочитать(); // Объект
		
		ИменаГрупп = Новый Структура;
		ИменаГрупп.Вставить("Атрибуты", "Attribute");
		ИменаГрупп.Вставить("Измерения", "Dimension");
		ИменаГрупп.Вставить("Ресурсы", "Resource");
		ИменаГрупп.Вставить("ТЧ", "TabularSection");
	Иначе
		// Формат EDT
		ЧтениеXML.Прочитать(); // mdclass:Объект
		
		ИменаГрупп = Новый Структура;
		ИменаГрупп.Вставить("Атрибуты", "attributes");
		ИменаГрупп.Вставить("Измерения", "dimensions");
		ИменаГрупп.Вставить("Ресурсы", "resources");
		ИменаГрупп.Вставить("ТЧ", "tabularSections");
	КонецЕсли;
	
	ЧтениеXML.Пропустить(); // InternalInfo или producedTypes
	ЧтениеXML.Прочитать();
	
	ИмяОбъекта = ПрочитатьСвойства(ЧтениеXML, "Name").Name;
	
	Пока НЕ ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Цикл
		Если ЭтоУзел(ЧтениеXML, ИменаГрупп.Атрибуты) Тогда
			ПрочитатьАтрибуты(ЧтениеXML, ОписаниеРеквизитов, ИменаГрупп.Атрибуты)
		ИначеЕсли ЭтоУзел(ЧтениеXML, ИменаГрупп.Измерения) Тогда
			ПрочитатьАтрибуты(ЧтениеXML, ОписаниеРеквизитов, ИменаГрупп.Измерения)
		ИначеЕсли ЭтоУзел(ЧтениеXML, ИменаГрупп.Ресурсы) Тогда
			ПрочитатьАтрибуты(ЧтениеXML, ОписаниеРесурсов, ИменаГрупп.Ресурсы);
		ИначеЕсли ЭтоУзел(ЧтениеXML, ИменаГрупп.ТЧ) Тогда
			ПрочитатьТабличныеЧасти(ЧтениеXML, ОписаниеРеквизитов, ОписаниеТабЧастей, ИменаГрупп.ТЧ, ИменаГрупп.Атрибуты);
		ИначеЕсли ЧтениеXML.Имя = "ChildObjects" Тогда
			ЧтениеXML.Прочитать();
		Иначе
			ЧтениеXML.Пропустить();
			ЧтениеXML.Прочитать();
		КонецЕсли;
	КонецЦикла;
	
	ЧтениеXML.Закрыть();
	
	Если ОписаниеРеквизитов.Количество() > 0 Тогда
		СтруктураОбъекта.Вставить("properties", ОписаниеРеквизитов);
	КонецЕсли;
	Если ОписаниеРесурсов.Количество() > 0 Тогда
		СтруктураОбъекта.Вставить("resources", ОписаниеРесурсов);
	КонецЕсли;
	Если ОписаниеТабЧастей.Количество() > 0 Тогда
		СтруктураОбъекта.Вставить("tabulars", ОписаниеТабЧастей);
	КонецЕсли;
	
	Возврат СтруктураОбъекта;
	
КонецФункции

Функция ПрочитатьСвойства(ЧтениеXML, СписокПолей, ТолькоИзСписка = Ложь)
	
	ОписаниеЭлемента = Новый Структура(СписокПолей);
	
	Если ЭтоУзел(ЧтениеXML, "Properties") Тогда
		ЧтениеXML.Прочитать();
	КонецЕсли;
	
	Если ТолькоИзСписка Тогда
		ОсталосьСвойств = ОписаниеЭлемента.Количество();
		Пока ЧтениеXML.ТипУзла <> ТипУзлаXML.КонецЭлемента Цикл
			Если ОсталосьСвойств = 0 Тогда
				Возврат ОписаниеЭлемента;
			КонецЕсли;
			ПрочитатьСвойствоСтруктуры(ЧтениеXML, ОписаниеЭлемента, ОсталосьСвойств);
		КонецЦикла;
	Иначе
		Пока ЧтениеXML.ТипУзла <> ТипУзлаXML.КонецЭлемента Цикл
			ПрочитатьСвойствоСтруктуры(ЧтениеXML, ОписаниеЭлемента);
		КонецЦикла;
	КонецЕсли;
	
	Если ЭтоКонецУзла(ЧтениеXML, "Properties") Тогда
		ЧтениеXML.Прочитать();
	КонецЕсли;
	
	Возврат ОписаниеЭлемента;
	
КонецФункции

Процедура ПрочитатьАтрибуты(ЧтениеXML, СтруктураРеквизитов, ИмяГруппы)
	
	Пока ЭтоУзел(ЧтениеXML, ИмяГруппы) Цикл
		ЧтениеXML.Прочитать();
		
		ОписаниеЭлемента = ПрочитатьСвойства(ЧтениеXML, "Name,Synonym");
		СтруктураРеквизитов.Вставить(ОписаниеЭлемента.Name, Новый Структура("name", ОписаниеЭлемента.Synonym));
		
		ЧтениеXML.Прочитать();
	КонецЦикла;
	
КонецПроцедуры

Процедура ПрочитатьТабличныеЧасти(ЧтениеXML, СтруктураРеквизитов, СтруктураТЧ, ИмяГруппыТЧ, ИмяГруппыАтрибуты)
	
	Пока ЭтоУзел(ЧтениеXML, ИмяГруппыТЧ) Цикл
		ЧтениеXML.Прочитать();
		
		ЧтениеXML.Пропустить(); // InternalInfo или producedTypes
		ЧтениеXML.Прочитать();
		
		ОписаниеТЧ = Новый Структура("Name,Synonym");
		ОписаниеРеквизитовТЧ = Неопределено;
		Пока НЕ ЭтоКонецУзла(ЧтениеXML, ИмяГруппыТЧ) Цикл
			Если ЭтоУзел(ЧтениеXML, ИмяГруппыАтрибуты) Тогда
				СтруктураРеквизитов.Вставить(ОписаниеТЧ.Name, Новый Структура("name", "ТЧ: " + ОписаниеТЧ.Synonym));
				
				ОписаниеРеквизитовТЧ = Новый Структура;
				ПрочитатьАтрибуты(ЧтениеXML, ОписаниеРеквизитовТЧ, ИмяГруппыАтрибуты);
				СтруктураТЧ.Вставить(ОписаниеТЧ.Name, ОписаниеРеквизитовТЧ);
				
				ОписаниеТЧ = Новый Структура("Name,Synonym");
				
			ИначеЕсли ЧтениеXML.Имя = "Properties" Тогда
				ЧтениеXML.Прочитать();
			ИначеЕсли ЧтениеXML.Имя = "ChildObjects" Тогда
				ЧтениеXML.Прочитать();
			Иначе
				ПрочитатьСвойствоСтруктуры(ЧтениеXML, ОписаниеТЧ);
			КонецЕсли;
		КонецЦикла;
		ЧтениеXML.Прочитать();
	КонецЦикла;
	
КонецПроцедуры

Функция ЭтоУзел(ЧтениеXML, ИмяУзла)
	Возврат ЧтениеXML.Имя = ИмяУзла И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента;
КонецФункции

Функция ЭтоКонецУзла(ЧтениеXML, ИмяУзла)
	Возврат ЧтениеXML.Имя = ИмяУзла И ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента;
КонецФункции

Процедура ПрочитатьСвойствоСтруктуры(ЧтениеXML, ОписаниеЭлемента, ОсталосьСвойств = 0)
	
	ИмяЭлемента = ЧтениеXML.Имя;
	Если ОписаниеЭлемента.Свойство(ИмяЭлемента) Тогда
		Если НРег(ИмяЭлемента) = "synonym" Тогда
			ПрочитатьМультистроку(ЧтениеXML, ОписаниеЭлемента, "ru", ОсталосьСвойств);
		Иначе
			ОписаниеЭлемента.Вставить(ИмяЭлемента, ПрочитатьЗначение(ЧтениеXML));
			ОсталосьСвойств = ОсталосьСвойств - 1;
		КонецЕсли;
	Иначе
		ЧтениеXML.Пропустить();
		ЧтениеXML.Прочитать();
	КонецЕсли;
	
КонецПроцедуры

Функция ПрочитатьЗначение(ЧтениеXML)
	
	ИмяЭлемента = ЧтениеXML.Имя;
	ЧтениеXML.Прочитать();
	
	Если ЭтоКонецУзла(ЧтениеXML, ИмяЭлемента) Тогда
		Значение = ""; // Пустой узел
	ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
		Значение = ЧтениеXML.Значение;
		ЧтениеXML.Прочитать();
	КонецЕсли;
	
	ЧтениеXML.Прочитать();
	
	Возврат Значение;
	
КонецФункции

Процедура ПрочитатьМультистроку(ЧтениеXML, СтруктураДляЗначения, КодЯзыка, ОсталосьСвойств)
	
	ИмяЭлемента = ЧтениеXML.Имя;
	ЧтениеXML.Прочитать();
	
	Пока НЕ ЭтоКонецУзла(ЧтениеXML, ИмяЭлемента) Цикл
		Если ЧтениеXML.Имя = "v8:item" Тогда
			ЧтениеXML.Прочитать();
		Иначе
			langKey = ПрочитатьЗначение(ЧтениеXML);
			contentValue = ПрочитатьЗначение(ЧтениеXML);
			Если langKey = КодЯзыка Тогда
				СтруктураДляЗначения.Вставить(ИмяЭлемента, contentValue);
				ОсталосьСвойств = ОсталосьСвойств - 1;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ЧтениеXML.Прочитать();
	
КонецПроцедуры

#КонецОбласти