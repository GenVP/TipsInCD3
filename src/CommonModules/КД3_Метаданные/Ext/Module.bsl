﻿
// Заполняет доступные конфигурации источника и приемника
//
// Параметры:
//  Конфигурации - Структура - структура с полями "Конфигурация", "КонфигурацияКорреспондент" для заполнения
//  СписокКонвертаций - СписокЗначений - список конвертаций
//  ЭтоКонвертацияXDTO - Булево - признак конвертации в формате XDTO
//  ОбъектИсточника - СправочникСсылка.Объекты - если заполнен, то выбранный на форме объект источника
//  ОбъектПриемника - СправочникСсылка.Объекты - если заполнен, то выбранный на форме объект приемника
//
Процедура ЗаполнитьКонфигурации(ДоступныеКонфигурации, СписокКонвертаций, ЭтоКонвертацияXDTO, ОбъектИсточника, ОбъектПриемника) Экспорт
	
	ТекстыЗапроса = Новый Массив;
	
	Если ДоступныеКонфигурации.Конфигурация = Неопределено Тогда
		ТекстыЗапроса.Добавить(
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	""Конфигурация"" КАК Ключ,
			|	Конвертации.Конфигурация КАК Конфигурация
			|ИЗ
			|	Справочник.Конвертации КАК Конвертации
			|ГДЕ
			|	Конвертации.Ссылка В(&СписокКонвертаций)");
	КонецЕсли;
	Если НЕ ЭтоКонвертацияXDTO И ДоступныеКонфигурации.КонфигурацияКорреспондент = Неопределено Тогда
		ТекстыЗапроса.Добавить(
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	""КонфигурацияКорреспондент"" КАК Ключ,
			|	Конвертации.КонфигурацияКорреспондент КАК Конфигурация
			|ИЗ
			|	Справочник.Конвертации КАК Конвертации
			|ГДЕ
			|	НЕ &ЭтоКонвертацияXDTO
			|	И Конвертации.Ссылка В(&СписокКонвертаций)");
	КонецЕсли;
	Если ТекстыЗапроса.Количество() > 0 Тогда
		РазделительЗапросов = "
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|";
		
		Запрос = Новый Запрос;
		Запрос.Текст = СтрСоединить(ТекстыЗапроса, РазделительЗапросов);
		Запрос.УстановитьПараметр("ЭтоКонвертацияXDTO", ЭтоКонвертацияXDTO);
		Запрос.УстановитьПараметр("СписокКонвертаций", СписокКонвертаций);
		
		РезультатЗапроса = Запрос.ВыполнитьПакет();
		
		Для Каждого ПакетЗапроса Из РезультатЗапроса Цикл
			ТаблицаКонфигураций = ПакетЗапроса.Выгрузить();
			Если ТаблицаКонфигураций.Количество() > 0 Тогда
				ДоступныеКонфигурации.Вставить(ТаблицаКонфигураций[0].Ключ, ТаблицаКонфигураций.ВыгрузитьКолонку("Конфигурация"));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОбъектИсточника) И ТипЗнч(ОбъектИсточника) = Тип("СправочникСсылка.Объекты") Тогда
		Конфигурация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектИсточника, "Владелец");
		// Сейчас можно сделать так, чтобы конфигурация объекта на будет соответствовать конфигурациям конвертаций
		Если ДоступныеКонфигурации.Конфигурация.Найти(Конфигурация) <> Неопределено Тогда
			ДоступныеКонфигурации.Конфигурация = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Конфигурация);
		КонецЕсли;
	КонецЕсли;
	Если НЕ ЭтоКонвертацияXDTO И ЗначениеЗаполнено(ОбъектПриемника) Тогда
		Конфигурация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектПриемника, "Владелец");
		// Сейчас можно сделать так, чтобы конфигурация объекта на будет соответствовать конфигурациям конвертаций
		Если ДоступныеКонфигурации.КонфигурацияКорреспондент.Найти(Конфигурация) <> Неопределено Тогда
			ДоступныеКонфигурации.КонфигурацияКорреспондент = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Конфигурация);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#Область Индексы_метаданных

Функция ОписаниеМетаданных(Конфигурация, КлючКоллекции, НастройкиКонфигурации = Неопределено, ЗаполнятьПриОтсутствии = Истина) Экспорт
	
	Если НастройкиКонфигурации = Неопределено Тогда
		НастройкиКонфигурации = НастройкиКонфигурации(Конфигурация);
	КонецЕсли;
	
	Если КлючКоллекции = "globalcontext" Тогда
		Возврат ОписаниеГлобальногоКонтекстаПоЗапросу(Конфигурация, НастройкиКонфигурации);
	КонецЕсли;
	
	Если НастройкиКонфигурации.МестоХраненияИндексов = 0 Тогда
		Возврат ПустоеОписаниеМетаданных();
	КонецЕсли;
	
	ОписаниеМетаданных = Неопределено;
	
	Если НастройкиКонфигурации.МестоХраненияИндексов = 2 Тогда
		КлючВладельца = "КД3_" + XMLСтрока(Конфигурация) + "_" + КлючКоллекции;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ Данные ИЗ РегистрСведений.БезопасноеХранилищеДанных ГДЕ Владелец = &КлючВладельца";
		Запрос.УстановитьПараметр("КлючВладельца", КлючВладельца);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ОписаниеМетаданных = Выборка.Данные.Получить();
		КонецЕсли;
		
	ИначеЕсли НастройкиКонфигурации.МестоХраненияИндексов = 1 Тогда
		
		ТестФайл = Новый Файл(НастройкиКонфигурации.КаталогИндексов + ПолучитьРазделительПутиСервера() + КлючКоллекции + ".json");
		Если ТестФайл.Существует() Тогда
			ЧтениеТекста = Новый ЧтениеТекста;
			ЧтениеТекста.Открыть(ТестФайл.ПолноеИмя, "UTF-8",,,Ложь);
			ОписаниеМетаданных = ЧтениеТекста.Прочитать();
		КонецЕсли;
	КонецЕсли;
	
	Если ОписаниеМетаданных = Неопределено И ЗаполнятьПриОтсутствии Тогда
		ОписаниеМетаданных = ОписаниеМетаданныхПоЗапросу(Конфигурация, КлючКоллекции, НастройкиКонфигурации);
	КонецЕсли;
	
	Возврат ОписаниеМетаданных;
	
КонецФункции

Процедура ЗаполнитьОписаниеСпискаМетаданных(Конфигурация, ОписанияМетаданных) Экспорт
	
	НастройкиКонфигурации = НастройкиКонфигурации(Конфигурация);
	Для Каждого КлючИЗначение Из ОписанияМетаданных Цикл
		ОписанияМетаданных.Вставить(КлючИЗначение.Ключ, ОписаниеМетаданных(Конфигурация, КлючИЗначение.Ключ, НастройкиКонфигурации));
	КонецЦикла;
	
КонецПроцедуры

Процедура ИзменитьОписаниеМетаданных(Конфигурация, КлючКоллекции, ДанныеДляСохранения, НастройкиКонфигурации = Неопределено) Экспорт
	
	Если НастройкиКонфигурации = Неопределено Тогда
		НастройкиКонфигурации = НастройкиКонфигурации(Конфигурация);
	КонецЕсли;
	Если НастройкиКонфигурации.МестоХраненияИндексов = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если НастройкиКонфигурации.МестоХраненияИндексов = 2 Тогда
		КлючВладельца = "КД3_" + XMLСтрока(Конфигурация) + "_" + КлючКоллекции;
		
		Если ТипЗнч(ДанныеДляСохранения) = Тип("Строка") Тогда
			ТекстJSON = ДанныеДляСохранения;
		Иначе
			ТекстJSON = ОбъектВСтрокуJSON(ДанныеДляСохранения);
		КонецЕсли;
		
		МенеджерЗаписи = РегистрыСведений.БезопасноеХранилищеДанных.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Владелец = КлючВладельца;
		МенеджерЗаписи.Данные = Новый ХранилищеЗначения(ТекстJSON, Новый СжатиеДанных(6));
		МенеджерЗаписи.Записать();
		
	ИначеЕсли НастройкиКонфигурации.МестоХраненияИндексов = 1 Тогда
		
		ПолноеИмяФайла = НастройкиКонфигурации.КаталогИндексов + ПолучитьРазделительПутиСервера() + КлючКоллекции + ".json";
		Если ТипЗнч(ДанныеДляСохранения) = Тип("Строка") Тогда
			ЗаписьТекста = Новый ЗаписьТекста;
			ЗаписьТекста.Открыть(ПолноеИмяФайла, "UTF-8");
			ЗаписьТекста.Записать(ДанныеДляСохранения);
			ЗаписьТекста.Закрыть();
		Иначе
			ЗаписьJSON = Новый ЗаписьJSON;
			ЗаписьJSON.ОткрытьФайл(ПолноеИмяФайла);
			ЗаписатьJSON(ЗаписьJSON, ДанныеДляСохранения);
			ЗаписьJSON.Закрыть();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьОписаниеМетаданных(Конфигурация, НастройкиКонфигурации = Неопределено) Экспорт
	
	Если НастройкиКонфигурации = Неопределено Тогда
		НастройкиКонфигурации = НастройкиКонфигурации(Конфигурация);
	КонецЕсли;
	
	Если НастройкиКонфигурации.МестоХраненияИндексов = 2 Тогда
		КлючВладельца = "КД3_" + XMLСтрока(Конфигурация);
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ Владелец ИЗ РегистрСведений.БезопасноеХранилищеДанных ГДЕ Владелец ПОДОБНО &КлючВладельца";
		Запрос.УстановитьПараметр("КлючВладельца", КлючВладельца + "%");
		
		МенеджерЗаписи = РегистрыСведений.БезопасноеХранилищеДанных.СоздатьМенеджерЗаписи();
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			МенеджерЗаписи.Владелец = Выборка.Владелец;
			МенеджерЗаписи.Удалить();
		КонецЦикла;
		
	ИначеЕсли НастройкиКонфигурации.МестоХраненияИндексов = 1 Тогда
		Попытка
			УдалитьФайлы(НастройкиКонфигурации.КаталогИндексов, "*.json");
		Исключение
			ТекстСообщения = СтрШаблон("Ошибка удаления старых индексов в каталоге ""%1"": %2", НастройкиКонфигурации.КаталогИндексов, ОписаниеОшибки());
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

Функция НастройкиКонфигурации(Конфигурация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ Данные ИЗ РегистрСведений.БезопасноеХранилищеДанных ГДЕ Владелец = &КлючВладельца";
	Запрос.УстановитьПараметр("КлючВладельца", КлючНастроекКонфигурации(Конфигурация));
	
	Настройки = Новый Структура;
	Настройки.Вставить("МестоХраненияИндексов", 0);
	Настройки.Вставить("КаталогИндексов", "");
	Настройки.Вставить("ЗагружатьМетодыМодулей", Ложь);
	Настройки.Вставить("ЗагружатьИзФайлов", Ложь);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Настройки, Выборка.Данные.Получить());
	КонецЕсли;
	
	Возврат Настройки;
	
КонецФункции

Процедура ИзменитьНастройкиКонфигурации(Конфигурация, Настройки) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.БезопасноеХранилищеДанных.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Владелец = КлючНастроекКонфигурации(Конфигурация);
	МенеджерЗаписи.Данные = Новый ХранилищеЗначения(Настройки, Новый СжатиеДанных(6));
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

Процедура УдалитьНастройкиКонфигурации(Конфигурация) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.БезопасноеХранилищеДанных.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Владелец = КлючНастроекКонфигурации(Конфигурация);
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() Тогда
		МенеджерЗаписи.Удалить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Локальный_контекст

Функция ОписаниеЛокальногоКонтекста(ПараметрыКонтекста, ИзмененныйКонтекст) Экспорт
	
	ОписаниеКонтекста = Новый Соответствие;
	
	// Получение шаблона описания локального контекста
	Если ПараметрыКонтекста.ИмяКонтекста = "ПРО" Тогда
		ВидКонтекста = "ПРО";
	ИначеЕсли ПараметрыКонтекста.ЭтоКонвертацияXDTO Тогда
		ВидКонтекста = "XDTO";
	Иначе
		ВидКонтекста = "XML";
	КонецЕсли;
	
	ШаблонКонтекста = СтрокаJSONвОбъект(ПолучитьОбщийМакет("КД3_ЛокальныйКонтекст" + ВидКонтекста).ПолучитьТекст());
	
	ОписаниеМетодов = ШаблонКонтекста.Методы;
	
	// Добавление общих переменных всех обработчиков
	ОписаниеПеременных = Новый Соответствие;
	ОписаниеПеременных.Вставить(Ложь, ШаблонКонтекста.Переменные);
	Если НЕ ПараметрыКонтекста.ЭтоКонвертацияXDTO И (
			ПараметрыКонтекста.ИмяКонтекста = "Конвертация"
		ИЛИ ПараметрыКонтекста.ИмяКонтекста = "ПКО"
		ИЛИ ПараметрыКонтекста.ИмяКонтекста = "ПКПД"
		ИЛИ ПараметрыКонтекста.ИмяКонтекста = "Алгоритм") Тогда
		// Есть разделение общих переменных на выгрузку/ загрузку
		ОписаниеПеременных.Вставить(Истина, ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(ШаблонКонтекста.Переменные));
	КонецЕсли;
	
	// Добавление переменных обработчиков
	Если ПараметрыКонтекста.ИмяКонтекста <> "Алгоритм" Тогда
		Для Каждого КлючИЗначение Из ШаблонКонтекста[ПараметрыКонтекста.ИмяКонтекста] Цикл
			ОписаниеКонтекста.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	
	ОписаниеКонтекста.Вставить("Переменные", ОписаниеПеременных);
	ОписаниеКонтекста.Вставить("Методы", ОписаниеМетодов);
	
	Если ВидКонтекста <> "ПРО" Тогда
		// Заполнение общих переменных
		ПеременнаяПараметры = ЗаполнитьЛокальныйКонтекст_Параметры(ПараметрыКонтекста);
		
		Если ВидКонтекста = "XML" Тогда
			ПеременнаяЗапросы = ЗаполнитьЛокальныйКонтекстXML_ЗапросыАлгоритмы(ПараметрыКонтекста, "Запросы");
			ПеременнаяАлгоритмы = ЗаполнитьЛокальныйКонтекстXML_ЗапросыАлгоритмы(ПараметрыКонтекста, "Алгоритмы");
			
			Для Каждого КлючИЗначение Из ОписаниеПеременных Цикл
				КлючИЗначение.Значение.Параметры.Вставить("properties", ПеременнаяПараметры[КлючИЗначение.Ключ]);
				КлючИЗначение.Значение.Запросы.Вставить("properties", ПеременнаяЗапросы[КлючИЗначение.Ключ]);
				КлючИЗначение.Значение.Алгоритмы.Вставить("properties", ПеременнаяАлгоритмы[КлючИЗначение.Ключ]);
			КонецЦикла;
			
		ИначеЕсли ВидКонтекста = "XDTO" Тогда
			ОписаниеПеременных[Ложь].КомпонентыОбмена.properties.ПараметрыКонвертации.Вставить("properties", ПеременнаяПараметры[Ложь]);
			
			ЗаполнитьЛокальныйКонтекстXDTO_Алгоритмы(ОписаниеКонтекста, ПараметрыКонтекста);
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьЛокальныйКонтекст(ПараметрыКонтекста, ОписаниеКонтекста, ИзмененныйКонтекст);
	
	Для Каждого КлючИЗначение Из ОписаниеКонтекста Цикл
		Если КлючИЗначение.Ключ = "Переменные" Тогда
			Для Каждого КлючИЗначение Из ОписаниеПеременных Цикл
				ОписаниеПеременных[КлючИЗначение.Ключ] = ОбъектВСтрокуJSON(КлючИЗначение.Значение);
			КонецЦикла;
		Иначе
			Если КлючИЗначение.Значение.Количество() = 0 Тогда
				ОписаниеКонтекста.Вставить(КлючИЗначение.Ключ, Неопределено);
			Иначе
				ОписаниеКонтекста.Вставить(КлючИЗначение.Ключ, ОбъектВСтрокуJSON(КлючИЗначение.Значение));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ОписаниеКонтекста;
	
КонецФункции

Процедура ОбновитьЛокальныйКонтекст(ПараметрыКонтекста, ОписаниеКонтекста, ИзмененныйКонтекст) Экспорт
	
	Если ПараметрыКонтекста.ИмяКонтекста = "Алгоритм" Тогда
		ОбновитьЛокальныйКонтекст_Алгоритм(ПараметрыКонтекста, ОписаниеКонтекста, ИзмененныйКонтекст);
		
	ИначеЕсли ПараметрыКонтекста.ИмяКонтекста = "Конвертация" Тогда
		ОбновитьЛокальныйКонтекст_Конвертация(ПараметрыКонтекста, ОписаниеКонтекста, ИзмененныйКонтекст);
		
	ИначеЕсли ИзмененныйКонтекст <> Неопределено Тогда
		
		// TODO Добавить описание остальных переменных в зависимости от типа
		Если ПараметрыКонтекста.ЭтоКонвертацияXDTO Тогда
			
		Иначе
			ШаблонОписания = Новый Структура;
			Если ПараметрыКонтекста.ИмяКонтекста = "ПКО" Тогда
				Если ИзмененныйКонтекст.Свойство("ОбъектКонфигурации") Тогда
					ИмяТипа = ИмяТипаОбъектаКД3(ИзмененныйКонтекст.ОбъектКонфигурации);
					ДобавитьПеременнуюКонтекста(ШаблонОписания, "Источник", ИмяТипа);
				КонецЕсли;
			КонецЕсли;
			ОбновитьЛокальныйКонтекстПоШаблону(ПараметрыКонтекста, ОписаниеКонтекста, ШаблонОписания);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПустоеОписаниеМетаданных()
	Возврат Новый Структура("count", 0);
КонецФункции

Функция ОписаниеМетаданныхПоЗапросу(Конфигурация, ПолноеИмяМетаданных, НастройкиКонфигурации)
	
	ЧастиИмени = СтрРазделить(ПолноеИмяМетаданных, ".");
	ЭтоМодуль = ЧастиИмени[0] = "module";
	
	Если НастройкиКонфигурации.ЗагружатьИзФайлов Тогда
		Если ЭтоМодуль Тогда
			Если ЧастиИмени.Количество() = 2 Тогда
				ОписаниеМетаданных = ЗагрузитьМодульОбъектаИзФайла(Конфигурация, "module", "общиемодули", ЧастиИмени[1]);
			Иначе
				ОписаниеМетаданных = ЗагрузитьМодульОбъектаИзФайла(Конфигурация, ЧастиИмени[1], ЧастиИмени[2], ЧастиИмени[3]);
			КонецЕсли;
		ИначеЕсли ЧастиИмени.Количество() = 1 Тогда
			ОписаниеМетаданных = ЗагрузитьКоллекциюОбъектовИзФайлов(Конфигурация, ЧастиИмени[0]);
		Иначе
			ОписаниеМетаданных = ЗагрузитьОбъектИзФайла(Конфигурация, ЧастиИмени[0], ЧастиИмени[1]);
		КонецЕсли;
	Иначе
		Если ЭтоМодуль Тогда
			ОписаниеМетаданных = Неопределено;
		ИначеЕсли ЧастиИмени.Количество() = 1 Тогда
			ОписаниеМетаданных = ОписатьКоллекциюОбъектовПоДаннымИБ(Конфигурация, ЧастиИмени[0]);
		Иначе
			ОписаниеМетаданных = ОписатьОбъектПоДаннымИБ(Конфигурация, ЧастиИмени[0], ЧастиИмени[1]);
		КонецЕсли;
	КонецЕсли;
	Если ОписаниеМетаданных = Неопределено Тогда
		ОписаниеМетаданных = ПустоеОписаниеМетаданных(); // Пустое описание метаданных для сохранения в кэше
	КонецЕсли;
	
	Возврат ОбъектВСтрокуJSON(ОписаниеМетаданных);
	
КонецФункции

Функция ОписаниеГлобальногоКонтекстаПоЗапросу(Конфигурация, НастройкиКонфигурации)
	
	ОписаниеОбщихМодулей = Новый Структура("ГлобальныеМодули,ОбщиеМодули");
	Если НастройкиКонфигурации.МестоХраненияИндексов <> 3 Тогда
		ОписаниеОбщихМодулей.ГлобальныеМодули = ОписаниеМетаданных(Конфигурация, "globalfunctions", НастройкиКонфигурации, Ложь);
		ОписаниеОбщихМодулей.ОбщиеМодули = ОписаниеМетаданных(Конфигурация, "commonmodules.items", НастройкиКонфигурации, Ложь);
	КонецЕсли;
	Если ОписаниеОбщихМодулей.ГлобальныеМодули = Неопределено И НастройкиКонфигурации.ЗагружатьИзФайлов Тогда
		ОписаниеОбщихМодулей = ЗагрузитьГлобальныйКонтекстИзФайлов(Конфигурация, НастройкиКонфигурации.ЗагружатьМетодыМодулей);
	КонецЕсли;
	
	Возврат ОписаниеОбщихМодулей;
	
КонецФункции

Функция ОписатьКоллекциюОбъектовПоДаннымИБ(Конфигурация, КорневойТип)
	
	ВсеКорневыеТипы = КД3_МетаданныеПовтИсп.ВсеКорневыеТипы(); 
	СтрокаТипа = ВсеКорневыеТипы.Найти(КорневойТип, "Мн");
	Если СтрокаТипа = Неопределено Тогда
		СтрокаТипа = ВсеКорневыеТипы.Найти(КорневойТип, "consoleL");		
	КонецЕсли;
	Если СтрокаТипа = Неопределено ИЛИ СтрокаТипа.НетВКД3 Тогда
		Возврат Неопределено; // Объекты этого типа нельзя получить из БД
	КонецЕсли;
	ТипОбъекта = Перечисления.ТипыОбъектов[СтрокаТипа.Ед];
	ИмяКоллекции = СтрокаТипа.console;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Объекты.Ссылка КАК Ссылка,
	|	Объекты.Имя КАК Имя
	|ИЗ
	|	Справочник.Объекты КАК Объекты
	|ГДЕ
	|	Объекты.Владелец = &Конфигурация
	|	И Объекты.Тип = &ТипОбъекта
	|	И НЕ Объекты.ПометкаУдаления";
	Запрос.УстановитьПараметр("Конфигурация", Конфигурация);
	Запрос.УстановитьПараметр("ТипОбъекта", ТипОбъекта);
	
	ОписаниеКоллекции = Новый Структура;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОписаниеКоллекции.Вставить(Выборка.Имя, Новый Структура);
	КонецЦикла;
	
	ОписаниеМетаданных = Новый Структура;
	ОписаниеМетаданных.Вставить("path", ИмяКоллекции + ".items");
	ОписаниеМетаданных.Вставить("data", ОписаниеКоллекции);
	ОписаниеМетаданных.Вставить("count", ОписаниеКоллекции.Количество());
	
	Возврат ОписаниеМетаданных;
	
КонецФункции

Функция ОписатьОбъектПоДаннымИБ(Конфигурация, КорневойТип, ИмяОбъекта)
	
	ВсеКорневыеТипы = КД3_МетаданныеПовтИсп.ВсеКорневыеТипы();
	СтрокаТипа = ВсеКорневыеТипы.Найти(КорневойТип, "Мн");
	Если СтрокаТипа = Неопределено Тогда
		СтрокаТипа = ВсеКорневыеТипы.Найти(КорневойТип, "consoleL");		
	КонецЕсли;
	Если СтрокаТипа = Неопределено ИЛИ СтрокаТипа.НетВКД3 Тогда
		Возврат Неопределено; // Объекты этого типа нельзя получить из БД
	КонецЕсли;
	
	ТипОбъекта = Перечисления.ТипыОбъектов[СтрокаТипа.Ед];
	ИмяКоллекции = СтрокаТипа.console;
	
	// Получение объекта
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Объекты.Ссылка КАК Ссылка,
	|	Объекты.Имя КАК Имя,
	|	Объекты.Периодичность КАК Периодичность
	|ИЗ
	|	Справочник.Объекты КАК Объекты
	|ГДЕ
	|	Объекты.Владелец = &Конфигурация
	|	И Объекты.Тип = &ТипОбъекта
	|	И Объекты.Имя = &ИмяОбъекта
	|	И НЕ ПометкаУдаления";
	Запрос.УстановитьПараметр("Конфигурация", Конфигурация);
	Запрос.УстановитьПараметр("ТипОбъекта", ТипОбъекта);
	Запрос.УстановитьПараметр("ИмяОбъекта", ИмяОбъекта);
	
	ВыборкаОбъект = Запрос.Выполнить().Выбрать();
	Если НЕ ВыборкаОбъект.Следующий() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// Получение реального имени объекта, так как в параметре оно в нижнем регистре
	ИмяОбъекта = ВыборкаОбъект.Имя;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Значения.Наименование КАК Наименование,
	|	Значения.Синоним КАК Синоним
	|ИЗ
	|	Справочник.Значения КАК Значения
	|ГДЕ
	|	Значения.Владелец = &Объект
	|	И НЕ Значения.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Свойства.Ссылка КАК Ссылка,
	|	Свойства.Родитель КАК Родитель,
	|	Свойства.Вид КАК Вид,
	|	Свойства.Наименование КАК Наименование,
	|	Свойства.Синоним КАК Синоним
	|ИЗ
	|	Справочник.Свойства КАК Свойства
	|ГДЕ
	|	Свойства.Владелец = &Объект
	|	И Свойства.Вид В(&ВидыСвойств)
	|	И НЕ ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Свойства.ЭтоГруппа УБЫВ";
	
	ОписаниеРеквизитов = Новый Структура;
	ОписаниеРесурсов = Новый Структура;
	ОписаниеПредопределенных = Новый Структура;
	ОписаниеТабЧастей = Новый Структура;
	
	СтруктураОбъекта = Новый Структура;
	СтруктураОбъекта.Вставить("properties", ОписаниеРеквизитов);
	СтруктураОбъекта.Вставить("predefined", ОписаниеПредопределенных);
	СтруктураОбъекта.Вставить("resources", ОписаниеРесурсов);
	СтруктураОбъекта.Вставить("tabulars", ОписаниеТабЧастей);
	
	ОписаниеМетаданных = Новый Структура;
	ОписаниеМетаданных.Вставить("path", СтрШаблон("%1.items.%2", ИмяКоллекции, ИмяОбъекта));
	ОписаниеМетаданных.Вставить("data", СтруктураОбъекта);
	ОписаниеМетаданных.Вставить("count", 1);
	
	ВидыСвойств = Новый Массив;
	ВидыСвойств.Добавить(Перечисления.ВидыСвойств.Свойство);
	ВидыСвойств.Добавить(Перечисления.ВидыСвойств.Реквизит);
	Если КД3_МетаданныеПовтИсп.КорневойТипРегистра(СтрокаТипа.Мн) Тогда
		ВидыСвойств.Добавить(Перечисления.ВидыСвойств.Измерение);
		ВидыСвойств.Добавить(Перечисления.ВидыСвойств.Ресурс);
	Иначе
		// Стандартное свойство Ссылка
		ОписаниеСвойства = Новый Структура("name", "");
		ДобавитьОписаниеТипаСвойстваПоДаннымИБ(ОписаниеСвойства, ВыборкаОбъект.Ссылка);
		ОписаниеРеквизитов.Вставить("Ссылка", ОписаниеСвойства);
	КонецЕсли;
	Если СтрокаТипа.ЕстьТЧ Тогда
		ВидыСвойств.Добавить(Перечисления.ВидыСвойств.ТабличнаяЧасть);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Объект", ВыборкаОбъект.Ссылка);
	Запрос.УстановитьПараметр("ВидыСвойств", ВидыСвойств);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	СоответствиеТабЧастей = Новый Соответствие;
	
	Если СтрокаТипа.ЕстьПредопределенные Тогда
		ВыборкаЗначений = РезультатЗапроса[0].Выбрать();
		Пока ВыборкаЗначений.Следующий() Цикл
			Если НЕ ПустаяСтрока(ВыборкаЗначений.Наименование) Тогда
				ОписаниеПредопределенных.Вставить(ВыборкаЗначений.Наименование);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ВыборкаСвойств = РезультатЗапроса[1].Выбрать();
	Пока ВыборкаСвойств.Следующий() Цикл
		Если ЗначениеЗаполнено(ВыборкаСвойств.Родитель) Тогда
			КоллекцияДляДобавления = СоответствиеТабЧастей[ВыборкаСвойств.Родитель];
			ОписаниеСвойства = Новый Структура("name", ВыборкаСвойств.Синоним);
			ДобавитьОписаниеТипаСвойстваПоДаннымИБ(ОписаниеСвойства, ВыборкаСвойств.Ссылка);
		Иначе
			КоллекцияДляДобавления = ?(ВыборкаСвойств.Вид = Перечисления.ВидыСвойств.Ресурс, ОписаниеРесурсов, ОписаниеРеквизитов);
			Если ВыборкаСвойств.Вид = Перечисления.ВидыСвойств.ТабличнаяЧасть Тогда
				ОписаниеТабЧасти = Новый Структура;
				ОписаниеТабЧастей.Вставить(ВыборкаСвойств.Наименование, Новый Структура("properties", ОписаниеТабЧасти));
				СоответствиеТабЧастей.Вставить(ВыборкаСвойств.Ссылка, ОписаниеТабЧасти);
				
				ОписаниеСвойства = Новый Структура("name", "ТЧ: " + ВыборкаСвойств.Синоним);
			Иначе
				ОписаниеСвойства = Новый Структура("name", ВыборкаСвойств.Синоним);
				ДобавитьОписаниеТипаСвойстваПоДаннымИБ(ОписаниеСвойства, ВыборкаСвойств.Ссылка);
			КонецЕсли;
		КонецЕсли;
		КоллекцияДляДобавления.Вставить(ВыборкаСвойств.Наименование, ОписаниеСвойства);
	КонецЦикла;
	
	Возврат ОписаниеМетаданных;
	
КонецФункции

Процедура ДобавитьОписаниеТипаСвойстваПоДаннымИБ(ОписаниеСвойства, СвойствоСсылка)
		
	ВсеКорневыеТипы = КД3_МетаданныеПовтИсп.ВсеКорневыеТипы();
	
	Если ТипЗнч(СвойствоСсылка) = Тип("СправочникСсылка.Объекты") Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ Наименование КАК Тип Из Справочник.Объекты ГДЕ Ссылка = &Ссылка");
	Иначе
		Запрос = Новый Запрос("ВЫБРАТЬ Тип.Наименование КАК Тип Из Справочник.Свойства.Типы ГДЕ Ссылка = &Ссылка");
	КонецЕсли;
	Запрос.УстановитьПараметр("Ссылка", СвойствоСсылка);
	
	МассивТипов = Новый Массив;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ПозТочки = СтрНайти(Выборка.Тип, ".");
		Если ПозТочки > 0 Тогда
			КорневойТип = СтрЗаменить(Лев(Выборка.Тип, ПозТочки - 1), "Ссылка", "");
			Имя = Сред(Выборка.Тип, ПозТочки + 1);
			СтрокаТипа = ВсеКорневыеТипы.Найти(КорневойТип, "Ед");
			Если СтрокаТипа <> Неопределено Тогда
				МассивТипов.Добавить(СтрокаТипа.console + "." + Имя); 
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	Если МассивТипов.Количество() > 0 Тогда
		ОписаниеСвойства.Вставить("ref", СтрСоединить(МассивТипов, ","));
	КонецЕсли;
	
КонецПроцедуры

Функция ИнициализацияПараметровЗагрузкиИзФайла(Конфигурация)
	
	ПараметрыЗагрузки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Конфигурация, "ИсточникДанных,КаталогЗагрузки,ЕстьРасширения,Расширения");
	
	ПараметрыЗагрузки.Вставить("ЭтоРасширение", Ложь);
	ПараметрыЗагрузки.Вставить("ПутьКФайламРасширения", "");
	ПараметрыЗагрузки.Вставить("ПомещенныеФайлы", Неопределено); // Прямой поиск по файлам
	ПараметрыЗагрузки.Вставить("КД3_ЭтоСервер", Истина);
	ПараметрыЗагрузки.Вставить("КД3_ИспользоватьКонтекстнуюПодсказку", Истина);
	
	Возврат ПараметрыЗагрузки;
	
КонецФункции

Функция ЗагрузитьГлобальныйКонтекстИзФайлов(Конфигурация, ЗагружатьМетодыМодулей)
	
	ПараметрыЗагрузки = ИнициализацияПараметровЗагрузкиИзФайла(Конфигурация);
	ПараметрыЗагрузки.Вставить("КД3_ЗагружатьМетодыМодулей", ЗагружатьМетодыМодулей);
	ПараметрыЗагрузки.Вставить("КД3_ПарсерМодулей", КД3_Настройки.ПарсерМодулей());
	
	КД3_ЗагрузкаМетаданных.ОбработатьГруппуОбщихМодулей(ПараметрыЗагрузки);
	
	Если ПараметрыЗагрузки.ЕстьРасширения Тогда
		ПараметрыЗагрузки.ЭтоРасширение = Истина;
		ВыборкаРасширение = ПараметрыЗагрузки.Расширения.Выбрать();
		Пока ВыборкаРасширение.Следующий() Цикл
			Если НЕ ПустаяСтрока(ВыборкаРасширение.ИмяКаталогаЗагрузки) Тогда
				ПараметрыЗагрузки.ПутьКФайламРасширения = ВыборкаРасширение.ИмяКаталогаЗагрузки;
				КД3_ЗагрузкаМетаданных.ОбработатьГруппуОбщихМодулей(ПараметрыЗагрузки);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ОписаниеОбщихМодулей = Новый Структура;
	ОписаниеОбщихМодулей.Вставить("ГлобальныеМодули", ОбъектВСтрокуJSON(КД3_ЗагрузкаМетаданных.КоллекцияОбъектов(ПараметрыЗагрузки, "globalfunctions", Истина)));
	ОписаниеОбщихМодулей.Вставить("ОбщиеМодули", ОбъектВСтрокуJSON(КД3_ЗагрузкаМетаданных.КоллекцияОбъектов(ПараметрыЗагрузки, "commonModules.items", Ложь)));
	
	Возврат ОписаниеОбщихМодулей;
	
КонецФункции

Функция ЗагрузитьКоллекциюОбъектовИзФайлов(Конфигурация, ИмяКоллекции)
	
	ПараметрыЗагрузки = ИнициализацияПараметровЗагрузкиИзФайла(Конфигурация);
	
	КлючКоллекции = Неопределено;
	
	КД3_ЗагрузкаМетаданных.ОбработатьГруппуОбъектов(ПараметрыЗагрузки, КлючКоллекции, ИмяКоллекции);
	
	Если ПараметрыЗагрузки.ЕстьРасширения Тогда
		ПараметрыЗагрузки.ЭтоРасширение = Истина;
		ВыборкаРасширение = ПараметрыЗагрузки.Расширения.Выбрать();
		Пока ВыборкаРасширение.Следующий() Цикл
			Если НЕ ПустаяСтрока(ВыборкаРасширение.ИмяКаталогаЗагрузки) Тогда
				ПараметрыЗагрузки.ПутьКФайламРасширения = ВыборкаРасширение.ИмяКаталогаЗагрузки;
				КД3_ЗагрузкаМетаданных.ОбработатьГруппуОбъектов(ПараметрыЗагрузки, КлючКоллекции, ИмяКоллекции);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат КД3_ЗагрузкаМетаданных.КоллекцияОбъектов(ПараметрыЗагрузки, КлючКоллекции, Ложь);
	
КонецФункции

Функция ЗагрузитьОбъектИзФайла(Конфигурация, ИмяКоллекции, ИмяОбъекта)
	
	ПараметрыЗагрузки = ИнициализацияПараметровЗагрузкиИзФайла(Конфигурация);
	
	КлючКоллекции = Неопределено;
	
	КД3_ЗагрузкаМетаданных.ОбработатьОбъект(ПараметрыЗагрузки, КлючКоллекции, ИмяКоллекции, ИмяОбъекта);
	
	Если ПараметрыЗагрузки.ЕстьРасширения Тогда
		ПараметрыЗагрузки.ЭтоРасширение = Истина;
		ВыборкаРасширение = ПараметрыЗагрузки.Расширения.Выбрать();
		Пока ВыборкаРасширение.Следующий() Цикл
			Если НЕ ПустаяСтрока(ВыборкаРасширение.ИмяКаталогаЗагрузки) Тогда
				ПараметрыЗагрузки.ПутьКФайламРасширения = ВыборкаРасширение.ИмяКаталогаЗагрузки;
				КД3_ЗагрузкаМетаданных.ОбработатьОбъект(ПараметрыЗагрузки, КлючКоллекции, ИмяКоллекции, ИмяОбъекта);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат КД3_ЗагрузкаМетаданных.КоллекцияОбъектов(ПараметрыЗагрузки, КлючКоллекции, Ложь);
	
КонецФункции

Функция ЗагрузитьМодульОбъектаИзФайла(Конфигурация, ВидМодуля, КорневойТип, ИмяОбъекта)
	
	ПараметрыЗагрузки = ИнициализацияПараметровЗагрузкиИзФайла(Конфигурация);
	ПараметрыЗагрузки.Вставить("КД3_ПарсерМодулей", КД3_Настройки.ПарсерМодулей());
	
	КлючКоллекции = Неопределено;
	
	КД3_ЗагрузкаМетаданных.ЗагрузитьМодульОбъекта(ПараметрыЗагрузки, КлючКоллекции, Конфигурация, ВидМодуля, КорневойТип, ИмяОбъекта);
	
	Если ПараметрыЗагрузки.ЕстьРасширения Тогда
		ПараметрыЗагрузки.ЭтоРасширение = Истина;
		ВыборкаРасширение = ПараметрыЗагрузки.Расширения.Выбрать();
		Пока ВыборкаРасширение.Следующий() Цикл
			Если НЕ ПустаяСтрока(ВыборкаРасширение.ИмяКаталогаЗагрузки) Тогда
				ПараметрыЗагрузки.ПутьКФайламРасширения = ВыборкаРасширение.ИмяКаталогаЗагрузки;
				КД3_ЗагрузкаМетаданных.ЗагрузитьМодульОбъекта(ПараметрыЗагрузки, КлючКоллекции, Конфигурация, ВидМодуля, КорневойТип, ИмяОбъекта);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат КД3_ЗагрузкаМетаданных.КоллекцияОбъектов(ПараметрыЗагрузки, КлючКоллекции, Истина);
	
КонецФункции

Функция КлючНастроекКонфигурации(Конфигурация)
	Возврат "КД3_Настройки_" + XMLСтрока(Конфигурация);
КонецФункции

Функция ОбъектВСтрокуJSON(ДанныеОбъекта)
	
	Если ДанныеОбъекта = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	ЗаписьJSON = Новый ЗаписьJSON();
	ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет));
	ЗаписатьJSON(ЗаписьJSON, ДанныеОбъекта);
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции

Функция СтрокаJSONвОбъект(ТекстJSON)
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ТекстJSON);
	Возврат ПрочитатьJSON(ЧтениеJSON);
	
КонецФункции

Функция ИмяТипаОбъектаКД3(ОбъектСсылка)
	
	Если НЕ ЗначениеЗаполнено(ОбъектСсылка) Тогда
		ИмяТипа = Неопределено;
	Иначе
		НаименованиеОбъекта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектСсылка, "Наименование");
		ПозТочки = СтрНайти(НаименованиеОбъекта, "Ссылка.");
		Если ПозТочки = Неопределено Тогда
			ИмяТипа = Неопределено; // Не ссылочный тип
		Иначе
			ВсеКорневыеТипы = КД3_МетаданныеПовтИсп.ВсеКорневыеТипы();
			СтрокаТипа = ВсеКорневыеТипы.Найти(Лев(НаименованиеОбъекта, ПозТочки - 1), "Ед");
			ИмяТипа = СтрокаТипа.consoleL + "." + Сред(НаименованиеОбъекта, ПозТочки + 7);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ИмяТипа;
	
КонецФункции

Процедура ОбновитьЛокальныйКонтекстПоШаблону(ПараметрыКонтекста, ОписаниеКонтекста, ШаблонОписания)
	
	Если ШаблонОписания.Количество() > 0 Тогда
		Для Каждого КлючИЗначение Из ОписаниеКонтекста Цикл
			Если КлючИЗначение.Ключ = "Переменные" ИЛИ КлючИЗначение.Ключ = "Методы" Тогда
				Продолжить; // Это не обработчик
			КонецЕсли;
			Если ПараметрыКонтекста.ЭтоИнициализация Тогда
				ОписаниеПеременных = КлючИЗначение.Значение;
			Иначе
				ОписаниеПеременных = СтрокаJSONвОбъект(КлючИЗначение.Значение);
			КонецЕсли;
			НужноЗаполнение = Ложь;
			Для Каждого ЭлементШаблона Из ШаблонОписания Цикл
				Если ОписаниеПеременных.Свойство(ЭлементШаблона.Ключ) Тогда
					НужноЗаполнение = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если НужноЗаполнение Тогда
				ЗаполнитьЗначенияСвойств(ОписаниеПеременных, ШаблонОписания);
				Если НЕ ПараметрыКонтекста.ЭтоИнициализация Тогда
					ОписаниеКонтекста.Вставить(КлючИЗначение.Ключ, ОбъектВСтрокуJSON(ОписаниеПеременных));
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Функция ЗаполнитьЛокальныйКонтекст_Параметры(ПараметрыКонтекста)
	
	ОписаниеПеременной = Новый Соответствие;
	ОписаниеПеременной.Вставить(Истина, Новый Структура);
	ОписаниеПеременной.Вставить(Ложь, Новый Структура);
	
	Если ПараметрыКонтекста.ИмяКонтекста <> "Конвертация" Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	КонвертацииПараметры.Параметр КАК Имя,
		|	КонвертацииПараметры.ИспользуетсяПриЗагрузке
		|		ИЛИ КонвертацииПараметры.ПередаватьПараметрПриВыгрузке КАК ДляКорреспондента
		|ИЗ
		|	Справочник.Конвертации.Параметры КАК КонвертацииПараметры
		|ГДЕ
		|	КонвертацииПараметры.Ссылка В(&Конвертации)";
		Запрос.УстановитьПараметр("Конвертации", ПараметрыКонтекста.Конвертации);
		
		РезультатЗапроса = Запрос.Выполнить();
		Если Не РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				ДобавитьПеременнуюКонтекста(ОписаниеПеременной[Выборка.ДляКорреспондента], СокрЛП(Выборка.Имя));
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ОписаниеПеременной;
	
КонецФункции

Функция ЗаполнитьЛокальныйКонтекстXML_ЗапросыАлгоритмы(ПараметрыКонтекста, ИмяПеременной)
	
	ОписаниеПеременной = Новый Соответствие;
	ОписаниеПеременной.Вставить(Истина, Новый Структура);
	ОписаниеПеременной.Вставить(Ложь, Новый Структура);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Правила.Код КАК Имя,
	|	Правила.ИспользуетсяПриЗагрузке КАК ДляКорреспондента
	|ИЗ
	|	Справочник.СоставыКонвертаций КАК СоставыКонвертаций
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник." + ИмяПеременной + " КАК Правила
	|		ПО (Правила.Ссылка = СоставыКонвертаций.ЭлементКонвертации)
	|ГДЕ
	|	СоставыКонвертаций.Владелец В (&Конвертации)
	|	И НЕ Правила.ПометкаУдаления");
	Запрос.УстановитьПараметр("Конвертации", ПараметрыКонтекста.Конвертации);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		ОписаниеПараметров = Новый Структура;
		ОписаниеПараметровКорреспондента = Новый Структура;
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ДобавитьПеременнуюКонтекста(ОписаниеПеременной[Выборка.ДляКорреспондента], СокрЛП(Выборка.Имя));
		КонецЦикла;
	КонецЕсли;
	
	Возврат ОписаниеПеременной;
	
КонецФункции

Процедура ЗаполнитьЛокальныйКонтекстXDTO_Алгоритмы(ОписаниеКонтекста, ПараметрыКонтекста)
	
	ОписаниеМетодов = ОписаниеКонтекста["Методы"];
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Правила.Код КАК Имя,
	|	Правила.Параметры КАК ПараметрыАлгоритма
	|ИЗ
	|	Справочник.СоставыКонвертаций КАК СоставыКонвертаций
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Алгоритмы КАК Правила
	|		ПО (Правила.Ссылка = СоставыКонвертаций.ЭлементКонвертации)
	|ГДЕ
	|	СоставыКонвертаций.Владелец В (&Конвертации)");
	Запрос.УстановитьПараметр("Конвертации", ПараметрыКонтекста.Конвертации);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ДобавитьМетодКонтекста(ОписаниеМетодов, СокрП(Выборка.Имя), СокрЛП(Выборка.ПараметрыАлгоритма), "Алгоритм");
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьЛокальныйКонтекст_Конвертация(ПараметрыКонтекста, ОписаниеКонтекста, ИзмененныйКонтекст)
	
	ОписаниеПеременной = Новый Соответствие;
	ОписаниеПеременной.Вставить(Истина, Новый Структура);
	ОписаниеПеременной.Вставить(Ложь, Новый Структура);
	Для Каждого ЭлементСписка Из ИзмененныйКонтекст.ПараметрыКонвертации Цикл
		ДобавитьПеременнуюКонтекста(ОписаниеПеременной[ЭлементСписка.Пометка], ЭлементСписка.Значение);
	КонецЦикла;
	
	// Обновление общих параметров
	ОписаниеПеременных = ОписаниеКонтекста["Переменные"];
	Если НЕ ПараметрыКонтекста.ЭтоИнициализация Тогда
		Для Каждого КлючИЗначение Из ОписаниеПеременных Цикл
			ОписаниеПеременных[КлючИЗначение.Ключ] = СтрокаJSONвОбъект(КлючИЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Если ПараметрыКонтекста.ЭтоКонвертацияXDTO Тогда
		ОписаниеПеременных[Ложь].КомпонентыОбмена.properties.ПараметрыКонвертации.Вставить("properties", ОписаниеПеременной[Ложь]);
	Иначе
		ОписаниеПеременных[Ложь].Параметры.Вставить("properties", ОписаниеПеременной[Ложь]);
		ОписаниеПеременных[Истина].Параметры.Вставить("properties", ОписаниеПеременной[Истина]);
	КонецЕсли;
	
	Если НЕ ПараметрыКонтекста.ЭтоИнициализация Тогда
		Для Каждого КлючИЗначение Из ОписаниеПеременных Цикл
			ОписаниеПеременных[КлючИЗначение.Ключ] = ОбъектВСтрокуJSON(КлючИЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьЛокальныйКонтекст_Алгоритм(ПараметрыКонтекста, ОписаниеКонтекста, ИзмененныйКонтекст)
	
	ОписаниеПеременной = Новый Структура;
	Если НЕ ПустаяСтрока(ИзмененныйКонтекст.Параметры) Тогда
		Попытка
			ПараметрыАлгоритма = Новый Структура(ИзмененныйКонтекст.Параметры);
			Для Каждого КлючИЗначение Из ПараметрыАлгоритма Цикл
				ДобавитьПеременнуюКонтекста(ОписаниеПеременной, СокрЛП(КлючИЗначение.Ключ));
			КонецЦикла;
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	Если НЕ ПараметрыКонтекста.ЭтоИнициализация Тогда
		ОписаниеПеременной = ОбъектВСтрокуJSON(ОписаниеПеременной);
	КонецЕсли;
	
	ОписаниеКонтекста.Вставить("Алгоритм", ОписаниеПеременной);
	
КонецПроцедуры

Процедура ДобавитьПеременнуюКонтекста(СтруктураПеременных, Имя, ИмяТипа = Неопределено)
	ОписаниеПеременной = Новый Структура;
	Если ИмяТипа <> Неопределено Тогда
		ОписаниеПеременной.Вставить("ref", ИмяТипа);
	КонецЕсли;
	Попытка
		СтруктураПеременных.Вставить(Имя, ОписаниеПеременной);
	Исключение
		ОбщегоНазначения.СообщитьПользователю(СтрШаблон("КД3:Неправильное имя переменной контекста ""%1""", Имя));
	КонецПопытки;
КонецПроцедуры

Процедура ДобавитьМетодКонтекста(СтруктураМетодов, Имя, Параметры, Описание)
	
	ОписаниеМетода = Новый Структура;
	ОписаниеМетода.Вставить("name", Имя);
	ОписаниеМетода.Вставить("description", Описание);
	ОписаниеМетода.Вставить("signature", Новый Структура("default", Новый Структура));
	
	МассивПараметров = СтрРазделить(Параметры, ",", Ложь);
	Если МассивПараметров.Количество() > 0 Тогда
		ОписаниеПараметров = Новый Структура;
		ОписаниеМетода.signature.default.Вставить("СтрокаПараметров", "(" + Параметры + ")");
		ОписаниеМетода.signature.default.Вставить("Параметры", ОписаниеПараметров);
		Для Каждого ИмяПараметра Из МассивПараметров Цикл
			ИмяПараметра = СокрЛ(ИмяПараметра);
			Если НРег(Лев(ИмяПараметра, 5)) = "знач " Тогда
				ИмяПараметра = Сред(ИмяПараметра, 5);
			КонецЕсли;
			ПозРавно = СтрНайти(ИмяПараметра, "=");
			Если ПозРавно <> 0 Тогда
				ИмяПараметра = Лев(ИмяПараметра, ПозРавно - 1);
			КонецЕсли;
			ИмяПараметра = СокрЛП(ИмяПараметра);
			ОписаниеПараметров.Вставить(ИмяПараметра, ИмяПараметра);
		КонецЦикла;
	КонецЕсли;
	
	СтруктураМетодов.Вставить(Имя, ОписаниеМетода);
	
КонецПроцедуры

#КонецОбласти
