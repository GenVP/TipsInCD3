﻿// Создает дополнительные реквизиты для контекстной подсказки, создает на закладках обработчиков 
// элементы выбора конфигураций (источника или приемника) и поля HTML-документов
//
// Параметры:
//  Форма
//  Отказ
//  ЭтоКонвертацияXDTO
//  Обработчики - Массив - массив имен реквизитов с текстом обработчиков
//  СтраницыОбработчиков
//
Процедура ПриСозданииНаСервере(Форма, Отказ, ЭтоКонвертацияXDTO, Обработчики, СтраницыОбработчиков) Экспорт
	
	ДобавитьРеквизитыФормы(Форма, ЭтоКонвертацияXDTO, Обработчики);
	
	ДоступныеКонфигурации = ДоступныеКонфигурации(Форма, ЭтоКонвертацияXDTO);
	
	Если ДоступныеКонфигурации.КонфигурацияЕстьНаФорме Тогда
		// Это открытие формы справочника "Конвертации"
		Форма.КД3_Конфигурация = ДоступныеКонфигурации.Конфигурация;
		Если НЕ ЭтоКонвертацияXDTO Тогда
			Форма.КД3_КонфигурацияКорреспондент = ДоступныеКонфигурации.КонфигурацияКорреспондент;
		КонецЕсли;
	Иначе
		ДобавитьЭлементыКонфигураций(Форма, ЭтоКонвертацияXDTO, СтраницыОбработчиков);
		УстановитьВидимостьКонфигураций(ДоступныеКонфигурации, ЭтоКонвертацияXDTO, Форма);
		
		Если ДоступныеКонфигурации.Конфигурация.Количество() > 0 Тогда
			 Форма.КД3_Конфигурация = ДоступныеКонфигурации.Конфигурация[0];
		КонецЕсли;
		Если ДоступныеКонфигурации.КонфигурацияКорреспондент.Количество() > 0 Тогда
			 Форма.КД3_КонфигурацияКорреспондент = ДоступныеКонфигурации.КонфигурацияКорреспондент[0];
		КонецЕсли;
	КонецЕсли;
	
	ДобавитьЭлементыОбработчиков(Форма, Обработчики, СтраницыОбработчиков);
	
КонецПроцедуры

Процедура ДобавитьРеквизитыФормы(Форма, ЭтоКонвертацияXDTO, Обработчики)
	
	ДобавляемыРеквизиты = Новый Массив;
	ДобавляемыРеквизиты.Добавить(Новый РеквизитФормы("КД3_Обработчики", Новый ОписаниеТипов("СписокЗначений")));
	ДобавляемыРеквизиты.Добавить(Новый РеквизитФормы("КД3_Конфигурация", Новый ОписаниеТипов("СправочникСсылка.Релизы")));
	Если НЕ ЭтоКонвертацияXDTO Тогда
		ДобавляемыРеквизиты.Добавить(Новый РеквизитФормы("КД3_КонфигурацияКорреспондент", Новый ОписаниеТипов("СправочникСсылка.Релизы")));
	КонецЕсли;
	//ТипСтрока = Новый ОписаниеТипов("Строка");
	//Для Каждого ЭлементСписка Из Обработчики Цикл
	//	ДобавляемыРеквизиты.Добавить(Новый РеквизитФормы("КД3_" + ЭлементСписка.Значение, ТипСтрока));
	//КонецЦикла;
	Форма.ИзменитьРеквизиты(ДобавляемыРеквизиты, Новый Массив);
	
КонецПроцедуры

Процедура ДобавитьЭлементыОбработчиков(Форма, Обработчики, СтраницыОбработчиков)
	
	Для Каждого ЭлементСписка Из Обработчики Цикл
		
		ИмяОбработчика = ЭлементСписка.Значение;
		ДляКорреспондента = ЭлементСписка.Пометка;
		
		ЭлементЭталон = Форма.Элементы[ИмяОбработчика];
		ЭлементЭталон.Видимость = Ложь;
		
		// Обработчики добавлены на форму вручную, так как не работает программное отключение контекстного меню
		//Элемент = Форма.Элементы.Добавить("КД3_" + ИмяОбработчика, Тип("ПолеФормы"), ЭлементЭталон.Родитель);
		//Элемент.Вид = ВидПоляФормы.ПолеHTMLДокумента;
		//Элемент.ПутьКДанным = "КД3_" + ИмяОбработчика;
		//Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		Элемент = Форма.Элементы["КД3_" + ИмяОбработчика];
		Элемент.Видимость = Истина;
		Элемент.УстановитьДействие("ДокументСформирован", "КД3_Подключаемый_ДокументСформирован");
		Элемент.УстановитьДействие("ПриНажатии", "КД3_Подключаемый_HTMLПриНажатии");
		Элемент.ТолькоПросмотр = ЭлементЭталон.ТолькоПросмотр;
		
		//Форма.КД3_Обработчики.Добавить(ИмяОбработчика,, ДляКорреспондента);
		Форма.КД3_Обработчики.Добавить(ИмяОбработчика, ЭлементСписка.Представление, ДляКорреспондента);
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьФайлМакетаИсходников() Экспорт
	Возврат ПоместитьВоВременноеХранилище(ПолучитьОбщийМакет("КД3_src"));
КонецФункции

Функция ПодкаталогИсходников() Экспорт
	
	// Получение уникального идентификатора текущей ИБ
	УИД_ИБ = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища("КД3", "УИД_ИБ");
	Если УИД_ИБ = Неопределено Тогда
		УИД_ИБ = СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище("КД3", УИД_ИБ, "УИД_ИБ");
	КонецЕсли;
	
	КаталогИсходников = "bsl_console" + СтрЗаменить(Метаданные.ОбщиеМакеты.КД3_src.Комментарий, ".", "") + "_" + УИД_ИБ;
	
	Возврат КаталогИсходников;
	
КонецФункции

Функция ЗагрузитьНастройки() Экспорт
	
	Настройки = НастройкиПоУмолчанию();
	Для Каждого КлючИЗначение Из Настройки Цикл
		НовоеЗначение = ХранилищеОбщихНастроек.Загрузить(Настройки.КлючНастроек, КлючИЗначение.Ключ);
		Если НовоеЗначение <> Неопределено Тогда
			Настройки.Вставить(КлючИЗначение.Ключ, НовоеЗначение);
		КонецЕсли;
	КонецЦикла;
	Настройки.Вставить("ИмяТемы", ПолноеИмяТемы(Настройки.Тема, Настройки.ПодсветкаЯзыкаЗапросов));
	
	Возврат Настройки;
	
КонецФункции

Процедура СохранитьНастройки(ТекущиеНастройки) Экспорт
	
	Настройки = НастройкиПоУмолчанию();
	ЗаполнитьЗначенияСвойств(Настройки, ТекущиеНастройки);
	Для Каждого КлючИЗначение Из Настройки Цикл
		ХранилищеОбщихНастроек.Сохранить(Настройки.КлючНастроек, КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
КонецПроцедуры

Функция НастройкиПоУмолчанию() Экспорт
	Настройки = Новый Структура;
	Настройки.Вставить("КлючНастроек", "КД3_Настройки");
	Настройки.Вставить("Тема", "bsl-white");
	Настройки.Вставить("НеОтображатьКартуКода", Ложь);
	Настройки.Вставить("ПодсветкаЯзыкаЗапросов", Ложь);
	Настройки.Вставить("УдалятьВременныеФайлыПриЗакрытии", Ложь);
	Возврат Настройки;
КонецФункции

Функция ПолноеИмяТемы(Тема, ПодсветкаЯзыкаЗапросов)
	
	Возврат Тема + ?(ПодсветкаЯзыкаЗапросов, "-query", "");
	
КонецФункции

// Вызывается при изменения конвертаций в которые входит объект
// Изменяет доступные для выбора конфигурации, связанные с подсказкой
//
// Параметры:
//  Форма
//  ЭтоКонвертацияXDTO
//
Процедура ПриИзмененииКонвертаций(Форма, ЭтоКонвертацияXDTO) Экспорт
	
	ДоступныеКонфигурации = ДоступныеКонфигурации(Форма, ЭтоКонвертацияXDTO);
	УстановитьВидимостьКонфигураций(ДоступныеКонфигурации, ЭтоКонвертацияXDTO, Форма);
	
	Если ДоступныеКонфигурации.Конфигурация.Найти(Форма.КД3_Конфигурация) = Неопределено Тогда
		Форма.КД3_Конфигурация = Справочники.Релизы.ПустаяСсылка();
	КонецЕсли;
	Если НЕ ЭтоКонвертацияXDTO Тогда
		Если ДоступныеКонфигурации.КонфигурацияКорреспондент.Найти(Форма.КД3_КонфигурацияКорреспондент) = Неопределено Тогда
			Форма.КД3_КонфигурацияКорреспондент = Справочники.Релизы.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ДоступныеКонфигурации(Форма, ЭтоКонвертацияXDTO)
	
	ПроверкаРеквизита = Новый Структура("СписокКонвертаций,ОбъектКонфигурации,ОбъектКонфигурацииКорреспондент,Конфигурация");
	ЗаполнитьЗначенияСвойств(ПроверкаРеквизита, Форма);
	Если ПроверкаРеквизита.СписокКонвертаций = Неопределено И ПроверкаРеквизита.ОбъектКонфигурации = Неопределено Тогда
		ДоступныеКонфигурации = Новый Структура;
		ДоступныеКонфигурации.Вставить("КонфигурацияЕстьНаФорме", Истина);
		Если ПроверкаРеквизита.Конфигурация = Неопределено Тогда
			// Это открытие формы справочника "Конвертации"
			ДоступныеКонфигурации.Вставить("Конфигурация", Форма.Объект.Конфигурация);
			Если НЕ ЭтоКонвертацияXDTO Тогда
				ДоступныеКонфигурации.Вставить("КонфигурацияКорреспондент", Форма.Объект.КонфигурацияКорреспондент);
			КонецЕсли;
		Иначе
			// Это открытие формы справочника "ПравилаРегистрацииОбъектов"
			ДоступныеКонфигурации.Вставить("Конфигурация", Форма.Конфигурация);
			ДоступныеКонфигурации.Вставить("КонфигурацияКорреспондент");
		КонецЕсли;
	Иначе
		Если ПроверкаРеквизита.СписокКонвертаций = Неопределено Тогда
			// Это открытие формы ПравилаКонвертацииСвойств
			ПроверкаРеквизита.СписокКонвертаций = Новый СписокЗначений;
			КонвертацияДанныхXDTOВызовСервера.ПолучитьВхожденияВКонвертацииДляЭлементаКонвертации(Форма.Объект.Владелец, ПроверкаРеквизита.СписокКонвертаций);
		КонецЕсли;
		ДоступныеКонфигурации = ПолучитьКонфигурации(ПроверкаРеквизита.СписокКонвертаций, ЭтоКонвертацияXDTO);
		ДоступныеКонфигурации.Вставить("КонфигурацияЕстьНаФорме", Ложь);
	КонецЕсли;
	
	Возврат ДоступныеКонфигурации;
	
КонецФункции

Процедура ДобавитьЭлементыКонфигураций(Форма, ЭтоКонвертацияXDTO, СтраницыОбработчиков)
	
	ЭлементГруппа = Форма.Элементы.Вставить("КД3_ГруппаКонфигурация", Тип("ГруппаФормы"), СтраницыОбработчиков.Родитель, СтраницыОбработчиков);
	ЭлементГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ЭлементГруппа.Поведение = ПоведениеОбычнойГруппы.Свертываемая;
	ЭлементГруппа.Заголовок = "Контекстная подсказка";
	
	Элемент = Форма.Элементы.Добавить("КД3_Конфигурация", Тип("ПолеФормы"), ЭлементГруппа);
	Элемент.Вид = ВидПоляФормы.ПолеВвода;
	Элемент.ПутьКДанным = "КД3_Конфигурация";
	Элемент.УстановитьДействие("ПриИзменении", "КД3_Подключаемый_ПриИзмененииКонфигурации");
	Элемент.РежимВыбораИзСписка = Истина;
	
	Если ЭтоКонвертацияXDTO Тогда
		Элемент.Заголовок = "Конфигурация";
	Иначе
		Элемент.Заголовок = "Конфигурация источник";
		
		ЭлементКорреспондент = Форма.Элементы.Добавить("КД3_КонфигурацияКорреспондент", Тип("ПолеФормы"), ЭлементГруппа);
		ЭлементКорреспондент.Вид = ВидПоляФормы.ПолеВвода;
		ЭлементКорреспондент.ПутьКДанным = "КД3_КонфигурацияКорреспондент";
		ЭлементКорреспондент.Заголовок = "Конфигурация приемник";
		ЭлементКорреспондент.УстановитьДействие("ПриИзменении", "КД3_Подключаемый_ПриИзмененииКонфигурацииКорреспондента");
		ЭлементКорреспондент.РежимВыбораИзСписка = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьВидимостьКонфигураций(ДоступныеКонфигурации, ЭтоКонвертацияXDTO, Форма)
	
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
	
	Форма.Элементы.КД3_ГруппаКонфигурация.Видимость = ВидимостьГруппы;
	
КонецПроцедуры

// Возвращает конфигурации в переданном список конвертаций
//
// Параметры:
//  СписокКонвертаций - СписокЗначений - список конвертаций
//
// Возвращаемое значение:
//  Структура - конфигурации конвертаций
//
Функция ПолучитьКонфигурации(СписокКонвертаций, ЭтоКонвертацияXDTO) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Конвертации.Конфигурация КАК Конфигурация
	|ИЗ
	|	Справочник.Конвертации КАК Конвертации
	|ГДЕ
	|	Конвертации.Ссылка В(&СписокКонвертаций)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Конвертации.КонфигурацияКорреспондент КАК Конфигурация
	|ИЗ
	|	Справочник.Конвертации КАК Конвертации
	|ГДЕ
	|	НЕ &ЭтоКонвертацияXDTO
	|	И Конвертации.Ссылка В(&СписокКонвертаций)";
	Запрос.УстановитьПараметр("ЭтоКонвертацияXDTO", ЭтоКонвертацияXDTO);
	Запрос.УстановитьПараметр("СписокКонвертаций", СписокКонвертаций);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Конфигурации = Новый Структура;
	
	Конфигурации.Вставить("Конфигурация", РезультатЗапроса[0].Выгрузить().ВыгрузитьКолонку("Конфигурация"));
	Конфигурации.Вставить("КонфигурацияКорреспондент", РезультатЗапроса[1].Выгрузить().ВыгрузитьКолонку("Конфигурация"));
	
	Возврат Конфигурации;
	
КонецФункции

// Возвращает сохраненные описания по метаданным конфигурации
// Метаданные генерируются в ЗагрузитьОписаниеМетаданных()
// 
// Параметры:
//  Конфигурация - СправочникСсылка.Конфигурации - конфигурация
//
// Возвращаемое значение:
//  Строка - адрес во временном хранилище сохраненных метаданных
//
Функция КоллекцияМетаданных(Конфигурация) Экспорт
	
	ДанныеВХранилище = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(КлючКэшаНастроек(Конфигурация));
	Если ДанныеВХранилище = Неопределено Тогда
		МетаданныеJSON = ЗагрузитьОписаниеМетаданных(Конфигурация);
	Иначе
		МетаданныеJSON = ДанныеВХранилище.Получить();
	КонецЕсли;
	
	Возврат ПоместитьВоВременноеХранилище(МетаданныеJSON);
	
КонецФункции

Процедура УдалитьКоллекциюМетаданных(Конфигурация) Экспорт
	ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(КлючКэшаНастроек(Конфигурация));
КонецПроцедуры

// Возвращает ключ под которым сохраняются описания метаданных конфигурации в кэше
//
// Параметры:
//  Конфигурация - СправочникСсылка.Конфигурации - конфигурация
//
// Возвращаемое значение:
//  Строка - ключ настроек
//
Функция КлючКэшаНастроек(Конфигурация)
	Возврат "КД3." + XMLСтрока(Конфигурация);
КонецФункции

// Выполняет заполнение описания метаданных по метаданным загруженным в КД3
//
// Параметры:
//  Конфигурация - СправочникСсылка.Конфигурации - конфигурация
//
Функция ЗагрузитьОписаниеМетаданных(Конфигурация) Экспорт
	
	КорневыеТипы = Новый Соответствие;
	КорневыеТипы.Вставить(Перечисления.ТипыОбъектов.Справочник, "Справочник");
	КорневыеТипы.Вставить(Перечисления.ТипыОбъектов.Документ, "Документ");
	КорневыеТипы.Вставить(Перечисления.ТипыОбъектов.РегистрСведений, "РегистрСведений");
	КорневыеТипы.Вставить(Перечисления.ТипыОбъектов.РегистрНакопления, "РегистрНакопления");
	КорневыеТипы.Вставить(Перечисления.ТипыОбъектов.РегистрБухгалтерии, "РегистрБухгалтерии");
	КорневыеТипы.Вставить(Перечисления.ТипыОбъектов.РегистрРасчета, "РегистрРасчета");
	КорневыеТипы.Вставить(Перечисления.ТипыОбъектов.Перечисление, "Перечисление");
	КорневыеТипы.Вставить(Перечисления.ТипыОбъектов.ПланСчетов, "ПланСчетов");
	КорневыеТипы.Вставить(Перечисления.ТипыОбъектов.БизнесПроцесс, "БизнесПроцесс");
	КорневыеТипы.Вставить(Перечисления.ТипыОбъектов.Задача, "Задача");
	КорневыеТипы.Вставить(Перечисления.ТипыОбъектов.ПланОбмена, "ПланОбмена");
	КорневыеТипы.Вставить(Перечисления.ТипыОбъектов.ПланВидовХарактеристик, "ПланВидовХарактеристик");
	КорневыеТипы.Вставить(Перечисления.ТипыОбъектов.ПланВидовРасчета, "ПланВидовРасчета");
	
	ЗапрашиваемыеОбъекты = Новый Массив;
	ЗапрашиваемыеОбъекты.Добавить("Справочники");
	ЗапрашиваемыеОбъекты.Добавить("Документы");
	ЗапрашиваемыеОбъекты.Добавить("РегистрыСведений");
	ЗапрашиваемыеОбъекты.Добавить("РегистрыНакопления");
	ЗапрашиваемыеОбъекты.Добавить("РегистрыБухгалтерии");
	ЗапрашиваемыеОбъекты.Добавить("РегистрыРасчета");
	//ЗапрашиваемыеОбъекты.Добавить("Обработки");
	//ЗапрашиваемыеОбъекты.Добавить("Отчеты");
	//ЗапрашиваемыеОбъекты.Добавить("ОбщиеМодули");
	ЗапрашиваемыеОбъекты.Добавить("Перечисления");
	ЗапрашиваемыеОбъекты.Добавить("ПланыСчетов");
	ЗапрашиваемыеОбъекты.Добавить("БизнесПроцессы");
	ЗапрашиваемыеОбъекты.Добавить("Задачи");
	ЗапрашиваемыеОбъекты.Добавить("ПланыОбмена");
	ЗапрашиваемыеОбъекты.Добавить("ПланыВидовХарактеристик");
	ЗапрашиваемыеОбъекты.Добавить("ПланыВидовРасчета");
	//ЗапрашиваемыеОбъекты.Добавить("Константы");
	
	Попытка
		ОписаниеМетаданных = ОписатьКоллекцииОбъектовМетаданых(Конфигурация, ЗапрашиваемыеОбъекты, КорневыеТипы);
		
		КоллекцияМетаданных = Новый Структура;
		КоллекцияМетаданных.Вставить("catalogs", ОписаниеМетаданных["Справочник"]);
		КоллекцияМетаданных.Вставить("documents", ОписаниеМетаданных["Документ"]);
		КоллекцияМетаданных.Вставить("infoRegs", ОписаниеМетаданных["РегистрСведений"]);
		КоллекцияМетаданных.Вставить("accumRegs", ОписаниеМетаданных["РегистрНакопления"]);
		КоллекцияМетаданных.Вставить("accountRegs", ОписаниеМетаданных["РегистрБухгалтерии"]);
		КоллекцияМетаданных.Вставить("calcRegs", ОписаниеМетаданных["РегистрРасчета"]);
		//КоллекцияМетаданных.Вставить("dataProc", ОписаниеМетаданных["Обработки"]);
		//КоллекцияМетаданных.Вставить("reports", ОписаниеМетаданных["Отчеты"]);
		КоллекцияМетаданных.Вставить("enums", ОписаниеМетаданных["Перечисление"]);
		КоллекцияМетаданных.Вставить("сhartsOfAccounts", ОписаниеМетаданных["ПланыСчетов"]);
		КоллекцияМетаданных.Вставить("businessProcesses", ОписаниеМетаданных["БизнесПроцессы"]);
		КоллекцияМетаданных.Вставить("tasks", ОписаниеМетаданных["Задачи"]);
		КоллекцияМетаданных.Вставить("exchangePlans", ОписаниеМетаданных["ПланыОбмена"]);
		КоллекцияМетаданных.Вставить("chartsOfCharacteristicTypes", ОписаниеМетаданных["ПланыВидовХарактеристик"]);
		КоллекцияМетаданных.Вставить("chartsOfCalculationTypes", ОписаниеМетаданных["ПланыВидовРасчета"]);
		
		Файл = Новый ЗаписьJSON();
		Файл.УстановитьСтроку();
		ЗаписатьJSON(Файл, КоллекцияМетаданных);
		МетаданныеJSON = Файл.Закрыть();
	Исключение
		МетаданныеJSON = "";
		ТекстСообщения = "Не удалось получить метаданных конфигурации:" + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	КонецПопытки;
	
	Попытка
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(КлючКэшаНастроек(Конфигурация), Новый ХранилищеЗначения(МетаданныеJSON));
	Исключение
		ТекстСообщения = "Не удалось сохранить метаданные конфигурации в ИБ" + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	КонецПопытки;
	
	Возврат МетаданныеJSON;
	
КонецФункции

Функция ОписатьКоллекцииОбъектовМетаданых(Конфигурация, Коллекции, КорневыеТипы)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Объекты.Ссылка КАК Ссылка,
	|	Объекты.Имя КАК Имя,
	|	Объекты.Тип КАК Тип
	|ПОМЕСТИТЬ Объекты
	|ИЗ
	|	Справочник.Объекты КАК Объекты
	|ГДЕ
	|	Объекты.Родитель В
	|			(ВЫБРАТЬ
	|				Объекты.Ссылка КАК Ссылка
	|			ИЗ
	|				Справочник.Объекты КАК Объекты
	|			ГДЕ
	|				Объекты.Владелец = &Конфигурация
	|				И Объекты.Наименование В (&Коллекции))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Объекты.Ссылка КАК Ссылка,
	|	Объекты.Имя КАК Имя,
	|	Объекты.Тип КАК Тип
	|ИЗ
	|	Объекты КАК Объекты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Значения.Владелец КАК Объект,
	|	Значения.Ссылка КАК Ссылка,
	|	Значения.Наименование КАК Наименование,
	|	Значения.Синоним КАК Синоним
	|ИЗ
	|	Справочник.Значения КАК Значения
	|ГДЕ
	|	Значения.Владелец В
	|			(ВЫБРАТЬ
	|				Объекты.Ссылка
	|			ИЗ
	|				Объекты)
	|ИТОГИ ПО
	|	Объект
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Свойства.Владелец КАК Объект,
	|	Свойства.Вид КАК Вид,
	|	Свойства.Ссылка КАК Ссылка,
	|	Свойства.Наименование КАК Наименование,
	|	Свойства.Синоним КАК Синоним
	|ИЗ
	|	Справочник.Свойства КАК Свойства
	|ГДЕ
	|	Свойства.Владелец В
	|			(ВЫБРАТЬ
	|				ОБъекты.Ссылка
	|			ИЗ
	|				ОБъекты)
	|ИТОГИ ПО
	|	Объект,
	|	Вид";
	Запрос.УстановитьПараметр("Конфигурация", Конфигурация);
	Запрос.УстановитьПараметр("Коллекции", Коллекции);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ВыборкаОбъектМетаданных = РезультатЗапроса[1].Выбрать();
	ВыборкаЗначенияОбъектов = РезультатЗапроса[2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаСвойстваОбъектов = РезультатЗапроса[3].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ОписаниеКоллекций = Новый Соответствие;
	
	Пока ВыборкаОбъектМетаданных.Следующий() Цикл
		
		КорневойТип = КорневыеТипы[ВыборкаОбъектМетаданных.Тип];
		//ПолноеИмя = КорневойТип + "." + ВыборкаОбъектМетаданных.Имя;
		
		ОписаниеКоллекции = ОписаниеКоллекций[КорневойТип];
		Если ОписаниеКоллекции = Неопределено Тогда
			ОписаниеКоллекции = Новый Структура;
			ОписаниеКоллекций.Вставить(КорневойТип, ОписаниеКоллекции);
		КонецЕсли;
		
		ДополнительныеСвойства = Новый Структура;
		ОписаниеРеквизитов = Новый Структура;
		ОписаниеРесурсов = Новый Структура;
		ОписаниеПредопределенных = Новый Структура;
		//ОписаниеТабличныхЧастей = Новый Структура;
		
		Если КорневойТипЗначений(КорневойТип) Тогда
			Если ВыборкаЗначенияОбъектов.НайтиСледующий(ВыборкаОбъектМетаданных.Ссылка, "Объект") Тогда
				Выборка = ВыборкаЗначенияОбъектов.Выбрать();
				Пока Выборка.Следующий() Цикл
					Если НЕ ПустаяСтрока(Выборка.Наименование) Тогда
						ОписаниеПредопределенных.Вставить(Выборка.Наименование);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
		Если ВыборкаСвойстваОбъектов.НайтиСледующий(ВыборкаОбъектМетаданных.Ссылка, "Объект") Тогда
			ВыборкаВидыСвойств = ВыборкаСвойстваОбъектов.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			ВидыСвойств = Новый Массив;
			ВидыСвойств.Добавить(Перечисления.ВидыСвойств.Реквизит);
			Если КорневойТипРегистра(КорневойТип) Тогда
				ВидыСвойств.Добавить(Перечисления.ВидыСвойств.Измерение);
				ВидыСвойств.Добавить(Перечисления.ВидыСвойств.Ресурс);
				//ЗаполнитьТипРегистра(ДополнительныеСвойства, ОбъектМетаданных, ПолноеИмя);
			КонецЕсли;
			
			Для Каждого ВидСвойства Из ВидыСвойств Цикл
				КоллекцияДляДобавления = ?(ВидСвойства = Перечисления.ВидыСвойств.Ресурс, ОписаниеРесурсов, ОписаниеРеквизитов);
				Если ВыборкаВидыСвойств.НайтиСледующий(ВидСвойства, "Вид") Тогда
					Выборка = ВыборкаВидыСвойств.Выбрать();
					Пока Выборка.Следующий() Цикл
						ОписаниеРеквизита = Новый Структура("name", Выборка.Синоним);
						КоллекцияДляДобавления.Вставить(Выборка.Наименование, ОписаниеРеквизита);
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		СтруктураОбъекта = Новый Структура;
		СтруктураОбъекта.Вставить("properties", ОписаниеРеквизитов);
		СтруктураОбъекта.Вставить("predefined", ОписаниеПредопределенных);
		СтруктураОбъекта.Вставить("resources", ОписаниеРесурсов);
		//СтруктураОбъекта.Вставить("tabulars", ОписаниеТабличныхЧастей);
		
		Для Каждого Обход Из ДополнительныеСвойства Цикл
			СтруктураОбъекта.Вставить(Обход.Ключ, Обход.Значение);
		КонецЦикла;
		
		ОписаниеКоллекции.Вставить(ВыборкаОбъектМетаданных.Имя, СтруктураОбъекта);
		
	КонецЦикла;
	
	Возврат ОписаниеКоллекций;
	
КонецФункции

Функция КорневойТипЗначений(КорневойТип)
	
	Возврат КорневойТип = "Перечисление" ИЛИ КорневойТип = "Справочник"
		ИЛИ КорневойТип = "ПланСчетов" ИЛИ КорневойТип = "ПланВидовХарактеристик";
	
КонецФункции

Функция КорневойТипРегистра(КорневойТип)
	
	Возврат КорневойТип = "РегистрСведений" ИЛИ КорневойТип = "РегистрНакопления"
		 ИЛИ КорневойТип = "РегистрБухгалтерии" ИЛИ КорневойТип = "РегистрРасчета";

КонецФункции
