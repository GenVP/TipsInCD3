﻿
// Вызывается при изменения конвертаций в которые входит объект
// Изменяет доступные для выбора конфигурации, связанные с подсказкой
//
// Параметры:
//  Форма
//  ЭтоКонвертацияXDTO
//
Процедура ПриИзмененииКонвертаций(Форма, ЭтоКонвертацияXDTO, ИзмененыМетаданные = Неопределено) Экспорт
	
	//Если НЕ КД3_Настройки.ИспользоватьКонтекстнуюПодсказку() Тогда
	//	Возврат;
	//КонецЕсли;
	
	ИзмененыМетаданные = Ложь;
	
	ДоступныеКонфигурации = КД3_УправлениеФормойКлиентСервер.ДоступныеКонфигурации(Форма, ЭтоКонвертацияXDTO);
	УстановитьВидимостьКонфигураций(ДоступныеКонфигурации, ЭтоКонвертацияXDTO, Форма);
	
	Если ДоступныеКонфигурации.Конфигурация.Найти(Форма.КД3_Конфигурация) = Неопределено Тогда
		ИзмененыМетаданные = Истина;
		Форма.КД3_Конфигурация = ПредопределенноеЗначение("Справочник.Релизы.ПустаяСсылка");
	КонецЕсли;
	Если НЕ ЭтоКонвертацияXDTO Тогда
		Если ДоступныеКонфигурации.КонфигурацияКорреспондент.Найти(Форма.КД3_КонфигурацияКорреспондент) = Неопределено Тогда
			ИзмененыМетаданные = Истина;
			Форма.КД3_КонфигурацияКорреспондент = ПредопределенноеЗначение("Справочник.Релизы.ПустаяСсылка");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьВидимостьКонфигураций(ДоступныеКонфигурации, ЭтоКонвертацияXDTO, Форма) Экспорт
	
	Элемент = Форма.Элементы.КД3_Конфигурация;
	Элемент.СписокВыбора.ЗагрузитьЗначения(ДоступныеКонфигурации.Конфигурация);
	Элемент.ТолькоПросмотр = ДоступныеКонфигурации.Конфигурация.Количество() = 1;
	
	ВидимостьГруппы = НЕ Элемент.ТолькоПросмотр;
	
	Если НЕ ЭтоКонвертацияXDTO Тогда
		ЭлементКорреспондент = Форма.Элементы.КД3_КонфигурацияКорреспондент;
		ЭлементКорреспондент.СписокВыбора.ЗагрузитьЗначения(ДоступныеКонфигурации.КонфигурацияКорреспондент);
		ЭлементКорреспондент.ТолькоПросмотр = ДоступныеКонфигурации.КонфигурацияКорреспондент.Количество() = 1;
		ВидимостьГруппы = ВидимостьГруппы ИЛИ НЕ ЭлементКорреспондент.ТолькоПросмотр;
	КонецЕсли;
	
	ВидимостьГруппы = Истина; // ТЕСТ
	Форма.Элементы.КД3_ГруппаКонфигурация.Видимость = ВидимостьГруппы;
	
КонецПроцедуры

Функция ДоступныеКонфигурации(Форма, ЭтоКонвертацияXDTO) Экспорт
	
	ПроверкаФормы = Новый Структура("СписокКонвертаций,Конфигурация,СписокКонфигураций,СписокКонфигурацийКорреспондент,ОбъектКонфигурации,ОбъектКонфигурацииКорреспондент");
	ПроверкаОбъекта = Новый Структура("Конфигурация,ОбъектКонфигурации,ОбъектКонфигурацииКорреспондент,ОбъектВыборки");
	ЗаполнитьЗначенияСвойств(ПроверкаФормы, Форма);
	ЗаполнитьЗначенияСвойств(ПроверкаОбъекта, Форма.Объект);
	
	ДоступныеКонфигурации = Новый Структура("КонфигурацияЕстьНаФорме,Конфигурация,КонфигурацияКорреспондент", Ложь);
	Если НЕ ЭтоКонвертацияXDTO Тогда
		ДоступныеКонфигурации.Вставить("КонфигурацияКорреспондент");
	КонецЕсли;
	
	Если ПроверкаФормы.СписокКонвертаций = Неопределено И ПроверкаФормы.Конфигурация <> Неопределено Тогда
		// Это открытие формы справочника "ПравилаРегистрацииОбъектов"
		ДоступныеКонфигурации.КонфигурацияЕстьНаФорме = Истина;
		ДоступныеКонфигурации.Конфигурация = Форма.Конфигурация;
		
	ИначеЕсли ПроверкаФормы.СписокКонвертаций = Неопределено И ПроверкаОбъекта.Конфигурация <> Неопределено Тогда
		
		// Это открытие формы справочника "Конвертации"
		ДоступныеКонфигурации.КонфигурацияЕстьНаФорме = Истина;
		ДоступныеКонфигурации.Конфигурация = ПроверкаОбъекта.Конфигурация;
		Если НЕ ЭтоКонвертацияXDTO Тогда
			ДоступныеКонфигурации.КонфигурацияКорреспондент = Форма.Объект.КонфигурацияКорреспондент;
		КонецЕсли;
		
	Иначе
		Если ПроверкаФормы.СписокКонвертаций = Неопределено Тогда
			// Это открытие формы элемента или группы ПравилаКонвертацииСвойств
			ПроверкаФормы.СписокКонвертаций = Новый СписокЗначений;
			КД3_УправлениеФормойВызовСервера.ПолучитьВхожденияВКонвертацииДляЭлементаКонвертации(Форма.Объект.Владелец, ПроверкаФормы.СписокКонвертаций);
			ЗаполнитьЗначенияСвойств(ПроверкаОбъекта, ПроверкаФормы, "ОбъектКонфигурации,ОбъектКонфигурацииКорреспондент");
		Иначе
			// На форме справочника ПравилаКонвертацииОбъектов и ПравилаКонвертацииПредопределенныхДанных уже есть список конфигураций
			Если ПроверкаФормы.СписокКонфигураций <> Неопределено Тогда
				ДоступныеКонфигурации.Конфигурация = ПроверкаФормы.СписокКонфигураций.ВыгрузитьЗначения();
				Если НЕ ЭтоКонвертацияXDTO Тогда
					ДоступныеКонфигурации.КонфигурацияКорреспондент = ПроверкаФормы.СписокКонфигурацийКорреспондент.ВыгрузитьЗначения();
				КонецЕсли;
			КонецЕсли;
			Если ПроверкаОбъекта.ОбъектВыборки <> Неопределено Тогда
				// Это открытие формы ПравилаОбработкиДанных
				ПроверкаОбъекта.ОбъектКонфигурации = ПроверкаОбъекта.ОбъектВыборки;
			КонецЕсли;
		КонецЕсли;
		
		КД3_УправлениеФормойВызовСервера.ЗаполнитьКонфигурации(ДоступныеКонфигурации, ПроверкаФормы.СписокКонвертаций, ЭтоКонвертацияXDTO,
			ПроверкаОбъекта.ОбъектКонфигурации, ПроверкаОбъекта.ОбъектКонфигурацииКорреспондент);
		ДоступныеКонфигурации.Вставить("КонфигурацияЕстьНаФорме", Ложь);
	КонецЕсли;
	
	Возврат ДоступныеКонфигурации;
	
КонецФункции
