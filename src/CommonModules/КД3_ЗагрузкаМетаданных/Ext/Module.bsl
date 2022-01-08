﻿
Процедура ОбработатьГруппуОбщихМодулей(ПараметрыЗагрузки, ЗагружатьМетодыНеГлобальныхМодулей = Ложь) Экспорт
	
	Разделитель = ПолучитьРазделительПутиСервера();
	
	Если ПараметрыЗагрузки.ИсточникДанных = 0 Тогда
		ВложенныеФайлы = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + "CommonModules" + Разделитель, ".xml", ПараметрыЗагрузки);
	Иначе
		ВложенныеФайлы = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + "src" + Разделитель + "CommonModules" + Разделитель, ".mdo", ПараметрыЗагрузки);
	КонецЕсли;
	Если ВложенныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеМетаданных = КоллекцияОбъектов(ПараметрыЗагрузки, "commonModules.items", Ложь);
	Для Каждого ВложенныйФайл Из ВложенныеФайлы Цикл
		
		СвойстваМодуля = Новый Структура("Global,Name", Ложь);
		ПрочитатьСвойстваОбъекта(ВложенныйФайл.ТекущееИмяФайла, СвойстваМодуля, ПараметрыЗагрузки.ИсточникДанных = 1);
		
		Если НЕ СвойстваМодуля.Global Тогда
			ОписаниеМетаданных.data.Вставить(СвойстваМодуля.Name, Новый Структура);
			Если ЗагружатьМетодыНеГлобальныхМодулей Тогда
				ДанныеМодуля = КоллекцияОбъектов(ПараметрыЗагрузки, "module." + СвойстваМодуля.Name, Истина);
				ДанныеМодуля.path = "commonModules.items." + СвойстваМодуля.Name;
			Иначе
				ДанныеМодуля = Неопределено;
			КонецЕсли;
			
		ИначеЕсли ПараметрыЗагрузки.КД3_ЗагружатьМетодыМодулей Тогда
			// Добавление методов глобального модуля
			ДанныеМодуля = КоллекцияОбъектов(ПараметрыЗагрузки, "globalfunctions", Истина);
		КонецЕсли;
		
		Если ДанныеМодуля <> Неопределено Тогда
			Если ПараметрыЗагрузки.ИсточникДанных = 0 Тогда
				ФайлТекста = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + "CommonModules" + Разделитель +
					СвойстваМодуля.Name + Разделитель + "Ext" + Разделитель, "Module.bsl", ПараметрыЗагрузки);
			Иначе
				ФайлТекста = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + "src" + Разделитель + "CommonModules" + Разделитель +
					СвойстваМодуля.Name + Разделитель, "Module.bsl", ПараметрыЗагрузки);
			КонецЕсли;
			Если ФайлТекста.Количество() = 1 Тогда
				ЗаполнитьМетодыМодуля(ДанныеМодуля, ФайлТекста[0].ТекущееИмяФайла, ПараметрыЗагрузки.КД3_Вычислитель);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// Модули приложения
	Если ПараметрыЗагрузки.ИсточникДанных = 0 Тогда
		ФайлыТекста = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + "Ext" + Разделитель, "ApplicationModule.bsl", ПараметрыЗагрузки);
	Иначе
		ФайлыТекста = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + "src" + Разделитель + "Configuration"  + Разделитель, "ApplicationModule.bsl", ПараметрыЗагрузки);
	КонецЕсли;
	Если ФайлыТекста.Количество() > 0 Тогда
		ДанныеМодуля = КоллекцияОбъектов(ПараметрыЗагрузки, "globalfunctions", Истина);
		Для Каждого ФайлТекста Из ФайлыТекста Цикл
			ЗаполнитьМетодыМодуля(ДанныеМодуля, ФайлТекста.ТекущееИмяФайла, ПараметрыЗагрузки.КД3_Вычислитель);
		КонецЦикла;
	КонецЕсли;
	
	ОписаниеМетаданных.count = ОписаниеМетаданных.data.Количество();
	
КонецПроцедуры

Процедура ОбработатьГруппуОбъектов(ПараметрыЗагрузки, КлючКоллекции, ИмяКоллекции) Экспорт
	
	СтрокаТипа = КД3_МетаданныеПовтИсп.ВсеКорневыеТипы().Найти(ИмяКоллекции, "Мн");
	
	Разделитель = ПолучитьРазделительПутиСервера();
	Если ПараметрыЗагрузки.ИсточникДанных = 0 Тогда
		ВложенныеФайлы = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + СтрокаТипа.МнEng + Разделитель, ".xml", ПараметрыЗагрузки);
	Иначе
		ВложенныеФайлы = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + "src" + Разделитель + СтрокаТипа.МнEng + Разделитель, ".mdo", ПараметрыЗагрузки);
	КонецЕсли;
	Если ВложенныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	КлючКоллекции = СтрокаТипа.console + ".items";
	ОписаниеМетаданных = КоллекцияОбъектов(ПараметрыЗагрузки, КлючКоллекции, Ложь);
	
	Для Каждого ВложенныйФайл Из ВложенныеФайлы Цикл
		ФайлОбъекта = Новый Файл(ВложенныйФайл.ТекущееИмяФайла);
		ОписаниеМетаданных.data.Вставить(ФайлОбъекта.ИмяБезРасширения, Новый Структура);
	КонецЦикла;
	ОписаниеМетаданных.Вставить("count", ОписаниеМетаданных.data.Количество());
	
КонецПроцедуры

Процедура ОбработатьОбъект(ПараметрыЗагрузки, КлючКоллекции, ИмяКоллекции, ИмяОбъекта) Экспорт
	
	СтрокаТипа = КД3_МетаданныеПовтИсп.ВсеКорневыеТипы().Найти(ИмяКоллекции, "Мн");
	
	Разделитель = ПолучитьРазделительПутиСервера();
	Если ПараметрыЗагрузки.ИсточникДанных = 0 Тогда
		ВложенныеФайлы = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + СтрокаТипа.МнEng + Разделитель, ИмяОбъекта + ".xml", ПараметрыЗагрузки);
	Иначе
		ВложенныеФайлы = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + "src" + Разделитель + СтрокаТипа.МнEng + Разделитель, ИмяОбъекта + ".mdo", ПараметрыЗагрузки);
	КонецЕсли;
	Если ВложенныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ФайлОбъекта = Новый Файл(ВложенныеФайлы[0].ИсходноеИмяФайла);
	КлючКоллекции = СтрШаблон("%1.items.%2", СтрокаТипа.console, ФайлОбъекта.ИмяБезРасширения);
	ОписаниеМетаданных = КоллекцияОбъектов(ПараметрыЗагрузки, КлючКоллекции, Ложь);
	ОписаниеМетаданных.count = 1;
	
	ПрочитатьСведенияОбОбъекте(ВложенныеФайлы[0].ТекущееИмяФайла, ПараметрыЗагрузки, ИмяКоллекции, ОписаниеМетаданных.data, ПараметрыЗагрузки.ИсточникДанных = 1);
	
	Если НЕ ПараметрыЗагрузки.ЭтоРасширение Тогда
		Если СтрокаТипа.ЕстьОбщийРеквизит Тогда
			ПолноеИмяОбъекта = СтрШаблон("%1.%2", СтрокаТипа.ЕдEng, ФайлОбъекта.ИмяБезРасширения);
			Разделитель = ПолучитьРазделительПутиСервера();
			Если ПараметрыЗагрузки.ИсточникДанных = 0 Тогда
				ВложенныеФайлы = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + "CommonAttributes" + Разделитель, ".xml", ПараметрыЗагрузки);
			Иначе
				ВложенныеФайлы = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + "src" + Разделитель + "CommonAttributes" + Разделитель, ".mdo", ПараметрыЗагрузки);
			КонецЕсли;
			Если ВложенныеФайлы.Количество() > 0 Тогда
				Для Каждого ВложенныйФайл Из ВложенныеФайлы Цикл
					ПрочитатьСведенияОбОбщемРеквизите(ВложенныйФайл.ТекущееИмяФайла, ОписаниеМетаданных.data, ПолноеИмяОбъекта, ПараметрыЗагрузки.ИсточникДанных = 1);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
		Если ПараметрыЗагрузки.ИсточникДанных = 0 И СтрокаТипа.ЕстьПредопределенные Тогда
			ВложенныеФайлы = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + СтрокаТипа.МнEng + Разделитель + ИмяОбъекта + Разделитель + "Ext" + Разделитель, "Predefined.xml", ПараметрыЗагрузки);
			Если ВложенныеФайлы.Количество() = 1 Тогда
				ПрочитатьСведенияОПредопределенныхИзXML(ВложенныеФайлы[0].ТекущееИмяФайла, ПараметрыЗагрузки, ОписаниеМетаданных.data);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗагрузитьМодульОбъекта(ПараметрыЗагрузки, КлючКоллекции, Конфигурация, ВидМодуля, КорневойТип, ИмяОбъекта) Экспорт
	
	СтрокаТипа = КД3_МетаданныеПовтИсп.ВсеКорневыеТипы().Найти(КорневойТип, "Мн");
	
	Разделитель = ПолучитьРазделительПутиСервера();
	Если ПараметрыЗагрузки.ИсточникДанных = 0 Тогда
		ФайлТекста = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + СтрокаТипа.МнEng + Разделитель +
			ИмяОбъекта + Разделитель + "Ext" + Разделитель, ?(ВидМодуля = "module", "", ВидМодуля) + "Module.bsl", ПараметрыЗагрузки);
	Иначе
		ФайлТекста = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + "src" + Разделитель + СтрокаТипа.МнEng + Разделитель +
			ИмяОбъекта + Разделитель, ?(ВидМодуля = "module", "", ВидМодуля) + "Module.bsl", ПараметрыЗагрузки);
	КонецЕсли;
	Если ФайлТекста.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Получение реального имени объекта
	Если ПараметрыЗагрузки.ИсточникДанных = 0 Тогда
		ФайлОбъекта = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + СтрокаТипа.МнEng + Разделитель, ИмяОбъекта + ".xml", ПараметрыЗагрузки);
	Иначе
		ФайлОбъекта = НайтиПомещенныеФайлыПоМаске(ПараметрыЗагрузки.ПомещенныеФайлы, Разделитель + "src" + Разделитель + СтрокаТипа.МнEng + Разделитель, ИмяОбъекта + ".mdo", ПараметрыЗагрузки);
	КонецЕсли;
	Если ФайлОбъекта.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ТекстФайл = Новый Файл(ФайлОбъекта[0].ИсходноеИмяФайла);
	ИмяОбъектаИзФайла = ТекстФайл.ИмяБезРасширения;
	
	Если ВидМодуля = "module" Тогда
		КлючКоллекции = СтрШаблон("%1.items.%2", СтрокаТипа.console, ИмяОбъектаИзФайла);
	Иначе
		КлючКоллекции = СтрШаблон("%1.items.%2.%3", СтрокаТипа.console, ИмяОбъектаИзФайла, НРЕг(ВидМодуля));
	КонецЕсли;
	ОписаниеМетаданных = КоллекцияОбъектов(ПараметрыЗагрузки, КлючКоллекции, Истина);
	ЗаполнитьМетодыМодуля(ОписаниеМетаданных, ФайлТекста[0].ТекущееИмяФайла, ПараметрыЗагрузки.КД3_Вычислитель);
	
КонецПроцедуры

Функция КоллекцияОбъектов(ПараметрыЗагрузки, КлючКоллекции, ЭтоМодуль) Экспорт
	
	Если КлючКоллекции = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	КД3_Конфигурация = Неопределено;
	Если НЕ ПараметрыЗагрузки.Свойство("КД3_Конфигурация", КД3_Конфигурация) Тогда
		КД3_Конфигурация = Новый Соответствие;
		ПараметрыЗагрузки.Вставить("КД3_Конфигурация", КД3_Конфигурация);
	КонецЕсли;
	
	КоллекцияОбъекта = КД3_Конфигурация[КлючКоллекции];
	Если КоллекцияОбъекта = Неопределено Тогда
		КоллекцияОбъекта = НоваяКоллекцияОбъектов(КлючКоллекции, ЭтоМодуль);
		КД3_Конфигурация.Вставить(КлючКоллекции, КоллекцияОбъекта);
	КонецЕсли;
	
	Возврат КоллекцияОбъекта;
	
КонецФункции

Функция НоваяКоллекцияОбъектов(КлючКоллекции, ЭтоМодуль)
	
	КоллекцияОбъекта = Новый Структура;
	КоллекцияОбъекта.Вставить("path", КлючКоллекции);
	КоллекцияОбъекта.Вставить("count", 0);
	Если ЭтоМодуль Тогда
		КоллекцияОбъекта.Вставить("module", Новый Структура);
	Иначе
		КоллекцияОбъекта.Вставить("data", Новый Структура);
	КонецЕсли;
	Возврат КоллекцияОбъекта;
	
КонецФункции

Процедура ЗаполнитьМетодыМодуля(ДанныеМодуля, ПолноеИмяФайла, КД3_Вычислитель)
	
	ЧтениеТекста = Новый ЧтениеТекста(ПолноеИмяФайла, "UTF-8",,, Ложь);
	ТекстМодуля = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();
	
	Выражение = "^(?<directive0>^&[А-Яа-я\w]*\s*)?\s*(?<comment>(?:^[^\n\S]*\/\/[^\r\n]*\n)*)\s*(?<directive1>^&[А-Яа-я\w]*\s*)?(?<type>процедура|функция)\s+(?<name>[А-Яа-я\w]+)\s*\((?<params>[^)]*)\)\s*(?<export>экспорт)";
	Совпадения = ВычислительНайтиСовпадения(КД3_Вычислитель, ТекстМодуля, Выражение, "Директива0,Описание,Директива1,Тип,Имя,Параметры,Экспорт");
	
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

Функция НайтиПомещенныеФайлыПоМаске(ПомещенныеФайлы, ВложенныйКаталог, РасширениеФайла, ПараметрыЗагрузки) Экспорт
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("ИсходноеИмяФайла");
	Результат.Колонки.Добавить("ТекущееИмяФайла");
	
	ИсключитьВложенныеКаталоги = (СтрНайти(РасширениеФайла, "mdo") = 0);
	
	Если ПомещенныеФайлы = Неопределено Тогда
		// Прямой поиск в файлах
		Если НЕ СтрНачинаетсяС(ВложенныйКаталог, ПолучитьРазделительПутиСервера()) Тогда
			ВложенныйКаталог = ПолучитьРазделительПутиСервера() + ВложенныйКаталог;
		КонецЕсли;
		Если ПараметрыЗагрузки.ЭтоРасширение Тогда
			НайденныеФайлы = НайтиФайлы(ПараметрыЗагрузки.ПутьКФайламРасширения + ВложенныйКаталог, "*" + РасширениеФайла, НЕ ИсключитьВложенныеКаталоги);
		Иначе
			НайденныеФайлы = НайтиФайлы(ПараметрыЗагрузки.КаталогЗагрузки + ВложенныйКаталог, "*" + РасширениеФайла, НЕ ИсключитьВложенныеКаталоги);
		КонецЕсли;
		Для Каждого НайденныйФайл Из НайденныеФайлы Цикл
			НовСтрока = Результат.Добавить();
			НовСтрока.ИсходноеИмяФайла = НайденныйФайл.ПолноеИмя;
			НовСтрока.ТекущееИмяФайла = НайденныйФайл.ПолноеИмя;
		КонецЦикла;
	Иначе
		// Поиск в подготовленных файлах
		Для Каждого ТекФайл Из ПомещенныеФайлы Цикл
			Если ТекФайл.ЭтоРасширение <> ПараметрыЗагрузки.ЭтоРасширение Тогда
				Продолжить;
			ИначеЕсли ПараметрыЗагрузки.ЭтоРасширение Тогда
				ЭтоНаше = СтрНайти(ТекФайл.ПолноеИмя, ПараметрыЗагрузки.ПутьКФайламРасширения) > 0;
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

Функция ПодключитьВычислитель(ПараметрыЗагрузки = Неопределено) Экспорт
	
	КД3_Вычислитель = Неопределено;
	Если ПараметрыЗагрузки <> Неопределено И ПараметрыЗагрузки.Свойство("КД3_Вычислитель", КД3_Вычислитель) Тогда
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
	
	Если ПараметрыЗагрузки <> Неопределено Тогда
		ПараметрыЗагрузки.Вставить("КД3_Вычислитель", КД3_Вычислитель);
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

Процедура ЗаполнитьТипРегистра(СтруктураОбъекта, ИмяКоллекции, ОписаниеОбъекта)
	
	Разделитель = ПолучитьРазделительПутиСервера();
	
	Если  ИмяКоллекции = "регистрысведений" Тогда
		Если ОписаниеОбъекта.InformationRegisterPeriodicity = "Nonperiodical" Тогда
			ТипРегистра = "nonperiodical";
		Иначе
			ТипРегистра = "periodical";
		КонецЕсли;
		
	ИначеЕсли ИмяКоллекции = "регистрынакопления" Тогда
		Если ОписаниеОбъекта.RegisterType = "Turnovers" Тогда
			ТипРегистра = "turnovers";
		Иначе
			ТипРегистра = "balance";
		КонецЕсли;
		
	Иначе
		ТипРегистра = "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТипРегистра) Тогда
		СтруктураОбъекта.Вставить("type", ТипРегистра);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьСтандартныеРеквизиты(СтруктураРеквизитов, ИмяКоллекции, ОписаниеОбъекта)
	
	Если ОписаниеОбъекта.Owners.Количество() > 0 Тогда
		ДобавитьРеквизит(СтруктураРеквизитов, "Владелец");
	КонецЕсли;
	
	Если ОписаниеОбъекта.Hierarchical Тогда
		Если ОписаниеОбъекта.HierarchyType <> "HierarchyOfItems" Тогда
			ДобавитьРеквизит(СтруктураРеквизитов, "ЭтоГруппа");
		КонецЕсли;
		ДобавитьРеквизит(СтруктураРеквизитов, "Родитель");
	КонецЕсли;
	
	Если ИмяКоллекции = "документы" Тогда
		ДобавитьРеквизит(СтруктураРеквизитов, "Ссылка");
		ДобавитьРеквизит(СтруктураРеквизитов, "Проведен");
		ДобавитьРеквизит(СтруктураРеквизитов, "ПометкаУдаления");
		ДобавитьРеквизит(СтруктураРеквизитов, "Дата");
		
	ИначеЕсли ИмяКоллекции = "справочники" ИЛИ ИмяКоллекции = "планывидовхарактеристик" Тогда
		ДобавитьРеквизит(СтруктураРеквизитов, "Ссылка");
		ДобавитьРеквизит(СтруктураРеквизитов, "ПометкаУдаления");
		ДобавитьРеквизит(СтруктураРеквизитов, "Предопределенный");
		Если ИмяКоллекции = "планывидовхарактеристик" И ОписаниеОбъекта.Type.Количество() > 0 Тогда
			ДобавитьРеквизит(СтруктураРеквизитов, "ТипЗначения");
		КонецЕсли;
		
	ИначеЕсли ИмяКоллекции = "бизнеспроцессы" Тогда
		ДобавитьРеквизит(СтруктураРеквизитов, "Ссылка");
		ДобавитьРеквизит(СтруктураРеквизитов, "Стартован");
		ДобавитьРеквизит(СтруктураРеквизитов, "Завершен");
		ДобавитьРеквизит(СтруктураРеквизитов, "ВедущаяЗадача");
		ДобавитьРеквизит(СтруктураРеквизитов, "Дата");
		ДобавитьРеквизит(СтруктураРеквизитов, "ПометкаУдаления");
		
	ИначеЕсли ИмяКоллекции = "задачи" Тогда
		ДобавитьРеквизит(СтруктураРеквизитов, "Ссылка");
		ДобавитьРеквизит(СтруктураРеквизитов, "Выполнена");
		ДобавитьРеквизит(СтруктураРеквизитов, "Дата");
		ДобавитьРеквизит(СтруктураРеквизитов, "ПометкаУдаления");
		
	ИначеЕсли ИмяКоллекции = "регистрыбухгалтерии" Тогда
		ДобавитьРеквизит(СтруктураРеквизитов, "Период");
		ДобавитьРеквизит(СтруктураРеквизитов, "Активность");
		ДобавитьРеквизит(СтруктураРеквизитов, "Регистратор");
		
		Если ОписаниеОбъекта.Correspondence Тогда
			ДобавитьРеквизит(СтруктураРеквизитов, "СчетДт");
			ДобавитьРеквизит(СтруктураРеквизитов, "СчетКт");
			ДобавитьРеквизит(СтруктураРеквизитов, "СубконтоДт");
			ДобавитьРеквизит(СтруктураРеквизитов, "СубконтоКт");
		Иначе
			ДобавитьРеквизит(СтруктураРеквизитов, "Счет");
			ДобавитьРеквизит(СтруктураРеквизитов, "Субконто");
		КонецЕсли;
		
	ИначеЕсли ИмяКоллекции = "регистрынакопления" Тогда
		ДобавитьРеквизит(СтруктураРеквизитов, "Период");
		ДобавитьРеквизит(СтруктураРеквизитов, "Активность");
		ДобавитьРеквизит(СтруктураРеквизитов, "Регистратор");
		Если ОписаниеОбъекта.RegisterType = "Balance" Тогда
			ДобавитьРеквизит(СтруктураРеквизитов, "ВидДвижения");
		КонецЕсли;
		
	ИначеЕсли ИмяКоллекции = "регистрысведений" Тогда
		ДобавитьРеквизит(СтруктураРеквизитов, "Активность");
		Если ОписаниеОбъекта.InformationRegisterPeriodicity <> "Nonperiodical" Тогда
			ДобавитьРеквизит(СтруктураРеквизитов, "Период");
		КонецЕсли;
		Если ОписаниеОбъекта.WriteMode = "RecorderSubordinate" Тогда
			ДобавитьРеквизит(СтруктураРеквизитов, "Регистратор");
		КонецЕсли;
		
	ИначеЕсли ИмяКоллекции = "регистрырасчета" Тогда
		ДобавитьРеквизит(СтруктураРеквизитов, "ПериодРегистрации");
		ДобавитьРеквизит(СтруктураРеквизитов, "Активность");
		ДобавитьРеквизит(СтруктураРеквизитов, "Сторно");
		ДобавитьРеквизит(СтруктураРеквизитов, "Регистратор");
		ДобавитьРеквизит(СтруктураРеквизитов, "ВидРасчета");
		Если ОписаниеОбъекта.ActionPeriod Тогда
			ДобавитьРеквизит(СтруктураРеквизитов, "ПериодДействия");
			ДобавитьРеквизит(СтруктураРеквизитов, "ПериодДействияНачало");
			ДобавитьРеквизит(СтруктураРеквизитов, "ПериодДействияКонец");
		КонецЕсли;
		Если ОписаниеОбъекта.BasePeriod Тогда
			ДобавитьРеквизит(СтруктураРеквизитов, "БазовыйПериодНачало");
			ДобавитьРеквизит(СтруктураРеквизитов, "БазовыйПериодКонец");
		КонецЕсли;
		
	ИначеЕсли ИмяКоллекции = "планывидоврасчета" Тогда
		ДобавитьРеквизит(СтруктураРеквизитов, "Ссылка");
		Если ОписаниеОбъекта.ActionPeriodUse Тогда
			ДобавитьРеквизит(СтруктураРеквизитов, "ПериодДействияБазовый");
		КонецЕсли;
		ДобавитьРеквизит(СтруктураРеквизитов, "ПометкаУдаления");
		
	ИначеЕсли ИмяКоллекции = "планыобмена" Тогда
		ДобавитьРеквизит(СтруктураРеквизитов, "Ссылка");
		ДобавитьРеквизит(СтруктураРеквизитов, "ПометкаУдаления");
		ДобавитьРеквизит(СтруктураРеквизитов, "ЭтотУзел");
		ДобавитьРеквизит(СтруктураРеквизитов, "НомерОтправленного");
		ДобавитьРеквизит(СтруктураРеквизитов, "НомерПринятого");
		
	ИначеЕсли ИмяКоллекции = "планысчетов" Тогда
		ДобавитьРеквизит(СтруктураРеквизитов, "Ссылка");
		ДобавитьРеквизит(СтруктураРеквизитов, "Забалансовый");
		ДобавитьРеквизит(СтруктураРеквизитов, "ПометкаУдаления");
		ДобавитьРеквизит(СтруктураРеквизитов, "Предопределенный");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПрочитатьСвойстваОбъекта(ПолноеИмяФайла, ОписаниеСвойств, ЭтоФорматEDT);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ПолноеИмяФайла);
	
	ЧтениеXML.Прочитать();
	
	Если ЭтоФорматEDT Тогда
		ЧтениеXML.Прочитать(); // mdclass:Объект
		Если ЭтоУзел(ЧтениеXML, "producedTypes") Тогда
			ЧтениеXML.Пропустить();
			ЧтениеXML.Прочитать();
		КонецЕсли;
	Иначе
		ЧтениеXML.Прочитать(); // MetaDataObject
		ЧтениеXML.Прочитать(); // Объект
		Если ЭтоУзел(ЧтениеXML, "InternalInfo") Тогда
			ЧтениеXML.Пропустить();
			ЧтениеXML.Прочитать();
		КонецЕсли;
	КонецЕсли;
	
	ПрочитатьСвойства(ЧтениеXML, ОписаниеСвойств, Истина);
	
КонецПроцедуры

Функция ПрочитатьСведенияОбОбъекте(ПолноеИмяФайла, ПараметрыЗагрузки, ИмяКоллекции, СтруктураОбъекта, ЭтоФорматEDT)
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ПолноеИмяФайла);
	
	//TODO: Типы объектов
	
	ОписаниеРеквизитов = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураОбъекта, "properties", Новый Структура);
	ОписаниеРесурсов = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураОбъекта, "resources", Новый Структура);
	ОписаниеТабЧастей = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураОбъекта, "tabulars", Новый Структура);
	ОписаниеПредопределенных = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураОбъекта, "predefined", Новый Структура);
	
	ОписаниеОбъекта = Новый Структура;
	ОписаниеОбъекта.Вставить("Hierarchical", Ложь);
	ОписаниеОбъекта.Вставить("HierarchyType");
	ОписаниеОбъекта.Вставить("Type", Новый Массив);
	ОписаниеОбъекта.Вставить("Owners", Новый Массив);
	ОписаниеОбъекта.Вставить("RegisterType");
	ОписаниеОбъекта.Вставить("InformationRegisterPeriodicity");
	ОписаниеОбъекта.Вставить("WriteMode");
	ОписаниеОбъекта.Вставить("Correspondence", Ложь);
	ОписаниеОбъекта.Вставить("ActionPeriod", Ложь);
	ОписаниеОбъекта.Вставить("BasePeriod", Ложь);
	ОписаниеОбъекта.Вставить("ActionPeriodUse", Ложь);

	ЧтениеXML.Прочитать();
	
	Если ЭтоФорматEDT Тогда
		ЧтениеXML.Прочитать(); // mdclass:Объект
		
		ИменаГрупп = Новый Структура;
		ИменаГрупп.Вставить("Атрибуты", "attributes");
		ИменаГрупп.Вставить("Измерения", "dimensions");
		ИменаГрупп.Вставить("Ресурсы", "resources");
		ИменаГрупп.Вставить("ТЧ", "tabularSections");
		
		Разделитель = ПолучитьРазделительПутиСервера();
		ЭтоПланСчетов = СтрНайти(ПолноеИмяФайла, Разделитель + "ChartsOfAccounts" + Разделитель) <> 0;
	Иначе
		ЧтениеXML.Прочитать(); // MetaDataObject
		ЧтениеXML.Прочитать(); // Объект
		
		ИменаГрупп = Новый Структура;
		ИменаГрупп.Вставить("Атрибуты", "Attribute");
		ИменаГрупп.Вставить("Измерения", "Dimension");
		ИменаГрупп.Вставить("Ресурсы", "Resource");
		ИменаГрупп.Вставить("ТЧ", "TabularSection");
	КонецЕсли;
	
	ЧтениеXML.Пропустить(); // InternalInfo или producedTypes
	ЧтениеXML.Прочитать();
	
	Если НЕ ЭтоФорматEDT Тогда
		ПрочитатьСвойства(ЧтениеXML, ОписаниеОбъекта);
	КонецЕсли;
	
	Пока НЕ ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Цикл
		ЗначениеПоУмолчанию = Неопределено;
		Если ЭтоФОрматEDT И ОписаниеОбъекта.Свойство(ЧтениеXML.Имя, ЗначениеПоУмолчанию) Тогда
			ИмяЭлемента = ЧтениеXML.Имя;
			ОписаниеОбъекта.Вставить(ИмяЭлемента, ПрочитатьЗначение(ЧтениеXML, ЗначениеПоУмолчанию));
		ИначеЕсли ЭтоУзел(ЧтениеXML, ИменаГрупп.Атрибуты) Тогда
			ПрочитатьАтрибуты(ЧтениеXML, ОписаниеРеквизитов, ИменаГрупп.Атрибуты)
		ИначеЕсли ЭтоУзел(ЧтениеXML, ИменаГрупп.Измерения) Тогда
			ПрочитатьАтрибуты(ЧтениеXML, ОписаниеРеквизитов, ИменаГрупп.Измерения)
		ИначеЕсли ЭтоУзел(ЧтениеXML, ИменаГрупп.Ресурсы) Тогда
			ПрочитатьАтрибуты(ЧтениеXML, ОписаниеРесурсов, ИменаГрупп.Ресурсы);
		ИначеЕсли ЭтоУзел(ЧтениеXML, ИменаГрупп.ТЧ) Тогда
			ПрочитатьТабличныеЧасти(ЧтениеXML, ОписаниеРеквизитов, ОписаниеТабЧастей, ИменаГрупп.ТЧ, ИменаГрупп.Атрибуты);
		ИначеЕсли ЧтениеXML.Имя = "ChildObjects" Тогда
			ЧтениеXML.Прочитать();
		ИначеЕсли ЭтоФорматEDT И ЭтоУзел(ЧтениеXML, "predefined") Тогда
			ПрочитатьПредопределенные(ЧтениеXML, ОписаниеПредопределенных, "items", ЭтоПланСчетов);
		Иначе
			ЧтениеXML.Пропустить();
			ЧтениеXML.Прочитать();
		КонецЕсли;
	КонецЦикла;
	
	ЧтениеXML.Закрыть();
	
	ЗаполнитьСтандартныеРеквизиты(ОписаниеРеквизитов, ИмяКоллекции, ОписаниеОбъекта);
	ЗаполнитьТипРегистра(СтруктураОбъекта, ИмяКоллекции, ОписаниеОбъекта);
	
	Если ОписаниеРеквизитов.Количество() > 0 Тогда
		СтруктураОбъекта.Вставить("properties", ОписаниеРеквизитов);
	КонецЕсли;
	Если ОписаниеРесурсов.Количество() > 0 Тогда
		СтруктураОбъекта.Вставить("resources", ОписаниеРесурсов);
	КонецЕсли;
	Если ОписаниеТабЧастей.Количество() > 0 Тогда
		СтруктураОбъекта.Вставить("tabulars", ОписаниеТабЧастей);
	КонецЕсли;
	Если ОписаниеПредопределенных.Количество() > 0 Тогда
		СтруктураОбъекта.Вставить("predefined", ОписаниеПредопределенных);
	КонецЕсли;
	
	Возврат СтруктураОбъекта;
	
КонецФункции

Процедура ПрочитатьСведенияОбОбщемРеквизите(ПолноеИмяФайла, СтруктураОбъекта, ПолноеИмяОбъекта, ЭтоФорматEDT)
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ПолноеИмяФайла);
	
	ОписаниеРеквизитов = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураОбъекта, "properties", Новый Структура);
	
	Если ЭтоФорматEDT Тогда
		ЧтениеXML.Прочитать();
		ЧтениеXML.Прочитать(); // mdclass:Объект
		
		ИмяУзлаСостава = "content";
	Иначе
		ЧтениеXML.Прочитать(); // MetaDataObject
		ЧтениеXML.Прочитать(); // Объект
		ЧтениеXML.Прочитать(); // CommonAttribute
		ЧтениеXML.Прочитать(); // Properties
		
		ИмяУзлаСостава = "Content";
	КонецЕсли;
	
	ОбъектИспользование = Неопределено;
	
	ОписаниеЭлемента = Новый Структура("Name,Synonym,AutoUse");
	ОсталосьСвойств = ОписаниеЭлемента.Количество();
	
	Пока НЕ ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Цикл
		Если ЭтоУзел(ЧтениеXML, ИмяУзлаСостава) Тогда
			Если НЕ ЭтоФорматEDT Тогда
				ЧтениеXML.Прочитать();
			КонецЕсли;
			Пока НЕ ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Цикл
				Если ОбъектИспользование = Неопределено Тогда
					ЧтениеXML.Прочитать();
					ЭлементМетаданные = ПрочитатьЗначение(ЧтениеXML);
					ЭлементИспользование = ПрочитатьЗначение(ЧтениеXML);
					Если ЭлементМетаданные = ПолноеИмяОбъекта Тогда
						ОбъектИспользование = ЭлементИспользование;
					КонецЕсли;
					Если НЕ ЭтоФорматEDT Тогда
						ЧтениеXML.Пропустить(); // ConditionalSeparation
						ЧтениеXML.Прочитать();
					КонецЕсли;
					ЧтениеXML.Прочитать();
				Иначе
					ЧтениеXML.Пропустить();
					ЧтениеXML.Прочитать();
				КонецЕсли;
			КонецЦикла;
			Если НЕ ЭтоФорматEDT Тогда
				ЧтениеXML.Прочитать();
			КонецЕсли;
		Иначе
			ПрочитатьСвойствоСтруктуры(ЧтениеXML, ОписаниеЭлемента, ОсталосьСвойств);
			Если ОсталосьСвойств = 0 Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если (ОписаниеЭлемента.AutoUse = "Use" И ОбъектИспользование <> "DontUse")
		ИЛИ (ОписаниеЭлемента.AutoUse = "DontUse" И ОбъектИспользование = "Use") Тогда
		ОписаниеРеквизитов.Вставить(ОписаниеЭлемента.Name, Новый Структура("name", ОписаниеЭлемента.Synonym));
	КонецЕсли;
	
КонецПроцедуры

Процедура ПрочитатьСведенияОПредопределенныхИзXML(ПолноеИмяФайла, ПараметрыЗагрузки, СтруктураОбъекта)
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ПолноеИмяФайла);
	
	ОписаниеПредопределенных = Новый Структура;
	
	ЧтениеXML.Прочитать();
	
	Разделитель = ПолучитьРазделительПутиСервера();
	ЭтоПланСчетов = СтрНайти(ПолноеИмяФайла, Разделитель + "ChartsOfAccounts" + Разделитель) <> 0;
	
	ПрочитатьПредопределенные(ЧтениеXML, ОписаниеПредопределенных, "Item", ЭтоПланСчетов);
	
	ЧтениеXML.Закрыть();
	
	Если ОписаниеПредопределенных.Количество() > 0 Тогда
		СтруктураОбъекта.Вставить("predefined", ОписаниеПредопределенных);
	КонецЕсли;
	
КонецПроцедуры

Функция ПрочитатьСвойства(ЧтениеXML, СписокПолей, ТолькоИзСписка = Ложь)
	
	Если ТипЗнч(СписокПолей) = Тип("Структура") Тогда
		ОписаниеЭлемента = СписокПолей;
	Иначе
		ОписаниеЭлемента = Новый Структура(СписокПолей);
	КонецЕсли;
	
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

Процедура ПрочитатьПредопределенные(ЧтениеXML, СтруктураПредопределенных, ИмяГруппы, ЭтоПланСчетов)
	
	ЧтениеXML.Прочитать(); // PredefinedData или predefined
	
	Пока ЭтоУзел(ЧтениеXML, ИмяГруппы) Цикл
		ЧтениеXML.Прочитать();
		
		ОписаниеЭлемента = Новый Структура("IsFolder,Name,Code", Ложь);
		ПрочитатьСвойства(ЧтениеXML, ОписаниеЭлемента);
		Если НЕ ОписаниеЭлемента.IsFolder Тогда
			Если ЭтоПланСчетов Тогда
				СтруктураПредопределенных.Вставить(ОписаниеЭлемента.Name, СтрШаблон("%1 (%2)", ОписаниеЭлемента.Name, ОписаниеЭлемента.Code));
			Иначе
				СтруктураПредопределенных.Вставить(ОписаниеЭлемента.Name, "");
			КонецЕсли;
		КонецЕсли;
		
		ЧтениеXML.Прочитать();
	КонецЦикла;
	
КонецПроцедуры

Процедура ПрочитатьАтрибуты(ЧтениеXML, СтруктураРеквизитов, ИмяГруппы)
	
	Пока ЭтоУзел(ЧтениеXML, ИмяГруппы) Цикл
		ЧтениеXML.Прочитать();
		
		ОписаниеЭлемента = ПрочитатьСвойства(ЧтениеXML, "Name,Synonym");
		ДобавитьРеквизит(СтруктураРеквизитов, ОписаниеЭлемента.Name, ОписаниеЭлемента.Synonym);
		
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
				ДобавитьРеквизит(СтруктураРеквизитов, ОписаниеТЧ.Name, "ТЧ: " + ОписаниеТЧ.Synonym);
				
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

Процедура ДобавитьРеквизит(СтруктураРеквизитов, ИмяРеквизита, СинонимРеквизита = "")
	СтруктураРеквизитов.Вставить(ИмяРеквизита, Новый Структура("name", СинонимРеквизита));
КонецПроцедуры

Функция ЭтоУзел(ЧтениеXML, ИмяУзла)
	Возврат ЧтениеXML.Имя = ИмяУзла И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента;
КонецФункции

Функция ЭтоКонецУзла(ЧтениеXML, ИмяУзла)
	Возврат ЧтениеXML.Имя = ИмяУзла И ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента;
КонецФункции

Процедура ПрочитатьСвойствоСтруктуры(ЧтениеXML, ОписаниеЭлемента, ОсталосьСвойств = 0)
	
	ИмяЭлемента = ЧтениеXML.Имя;
	ЗначениеПоУмолчанию = Неопределено;
	Если ОписаниеЭлемента.Свойство(ИмяЭлемента, ЗначениеПоУмолчанию) Тогда
		Если НРег(ИмяЭлемента) = "synonym" Тогда
			ПрочитатьМультистроку(ЧтениеXML, ОписаниеЭлемента, "ru", ОсталосьСвойств);
		Иначе
			ОписаниеЭлемента.Вставить(ИмяЭлемента, ПрочитатьЗначение(ЧтениеXML, ЗначениеПоУмолчанию));
			ОсталосьСвойств = ОсталосьСвойств - 1;
		КонецЕсли;
	Иначе
		ЧтениеXML.Пропустить();
		ЧтениеXML.Прочитать();
	КонецЕсли;
	
КонецПроцедуры

Функция ПрочитатьЗначение(ЧтениеXML, ЗначениеПоУмолчанию = Неопределено)
	
	ИмяЭлемента = ЧтениеXML.Имя;
	
	Если ТипЗнч(ЗначениеПоУмолчанию) = Тип("Массив") Тогда
		ЧтениеXML.Прочитать();
		// Для описания типов и типов владельцев считывается только их наличие
		Значение = ЗначениеПоУмолчанию;
		Если НЕ ЭтоКонецУзла(ЧтениеXML, ИмяЭлемента) Тогда
			Значение.Добавить("<есть элемент>"); // не пустой узел
			Пока НЕ ЭтоКонецУзла(ЧтениеXML, ИмяЭлемента) Цикл
				Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
					ЧтениеXML.Пропустить();
				КонецЕсли;
				ЧтениеXML.Прочитать();
			КонецЦикла;
		КонецЕсли;
		ЧтениеXML.Прочитать();
	Иначе
		Значение = ЗначениеПоУмолчанию;
		Пока НЕ ЭтоКонецУзла(ЧтениеXML, ИмяЭлемента) Цикл
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
				Значение = ЧтениеXML.Значение;
			КонецЕсли;
			ЧтениеXML.Прочитать();
		КонецЦикла;
		ЧтениеXML.Прочитать();
		
		Если ЗначениеПоУмолчанию <> Неопределено Тогда
			Значение = XMLЗначение(ТипЗнч(ЗначениеПоУмолчанию), Значение);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

Процедура ПрочитатьМультистроку(ЧтениеXML, СтруктураДляЗначения, КодЯзыка, ОсталосьСвойств)
	
	ИмяЭлемента = ЧтениеXML.Имя;
	ЧтениеXML.Прочитать();
	
	Значение = "";
	Пока НЕ ЭтоКонецУзла(ЧтениеXML, ИмяЭлемента) Цикл
		Если ЧтениеXML.Имя = "v8:item" Тогда
			ЧтениеXML.Прочитать();
		Иначе
			langKey = ПрочитатьЗначение(ЧтениеXML);
			contentValue = ПрочитатьЗначение(ЧтениеXML);
			Если langKey = КодЯзыка Тогда
				Значение = contentValue;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ЧтениеXML.Прочитать();
	
	СтруктураДляЗначения.Вставить(ИмяЭлемента, Значение);
	ОсталосьСвойств = ОсталосьСвойств - 1;
	
КонецПроцедуры

#КонецОбласти