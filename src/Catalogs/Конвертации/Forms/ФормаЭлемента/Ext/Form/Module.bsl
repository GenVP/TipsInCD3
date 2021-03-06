﻿
&НаСервере
Процедура КД3_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Если НЕ КД3_Метаданные.ИспользоватьРедакторКода() Тогда
		Возврат;
	КонецЕсли;
	
	Обработчики = Новый СписокЗначений;
	
	Если КонвертацияXDTO Тогда
		Обработчики.Добавить("АлгоритмПередКонвертацией");
		Обработчики.Добавить("АлгоритмПередОтложеннымЗаполнением");
		Обработчики.Добавить("АлгоритмПослеКонвертации");
		СтраницыОбработчиков = Элементы.СтраницыОбработчики;
	Иначе
		Обработчики.Добавить("АлгоритмПослеЗагрузкиПравилОбмена");
		Обработчики.Добавить("АлгоритмПередВыгрузкойДанных");
		Обработчики.Добавить("АлгоритмПередПолучениемИзмененныхОбъектов");
		Обработчики.Добавить("АлгоритмПередВыгрузкойОбъекта");
		Обработчики.Добавить("АлгоритмПередОтправкойИнформацииОбУдалении");
		Обработчики.Добавить("АлгоритмПередКонвертациейОбъекта");
		Обработчики.Добавить("АлгоритмПослеВыгрузкиОбъекта");
		Обработчики.Добавить("АлгоритмПослеВыгрузкиДанных");
		Обработчики.Добавить("АлгоритмПередЗагрузкойДанных", , Истина);
		Обработчики.Добавить("АлгоритмПослеЗагрузкиПараметров", , Истина);
		Обработчики.Добавить("АлгоритмПослеПолученияИнформацииОбУзлахОбмена", , Истина);
		Обработчики.Добавить("АлгоритмПередЗагрузкойОбъекта", , Истина);
		Обработчики.Добавить("АлгоритмПриПолученииИнформацииОбУдалении", , Истина);
		Обработчики.Добавить("АлгоритмПослеЗагрузкиОбъекта", , Истина);
		Обработчики.Добавить("АлгоритмПослеЗагрузкиДанных", , Истина);
		СтраницыОбработчиков = Элементы.ОбработчикиXML;
	КонецЕсли;
	КД3_Метаданные.ПриСозданииНаСервере(ЭтотОбъект, Отказ, КонвертацияXDTO, Обработчики, СтраницыОбработчиков);
	
	Элементы.Страницы.УстановитьДействие("ПриСменеСтраницы", "КД3_Подключаемый_СтраницыПриСменеСтраницы");
	Элементы.ГруппаДанныеКонвертацииXDTO.УстановитьДействие("ПриСменеСтраницы", "КД3_Подключаемый_ГруппаДанныеКонвертацииXDTOПриСменеСтраницы");
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_ПриОткрытииПосле(Отказ)
	Если НЕ КонвертацияXDTO Тогда
		КД3_МетаданныеКлиент.ПриСменеСтраницы(ЭтотОбъект, Элементы.ОбработчикиXML.ТекущаяСтраница);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КД3_ПередЗаписьюПосле(Отказ, ПараметрыЗаписи)
	КД3_МетаданныеКлиент.ПередЗаписью(ЭтотОбъект, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура КД3_ОбработкаОповещенияПосле(ИмяСобытия, Параметр, Источник)
	КД3_МетаданныеКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр);
КонецПроцедуры

&НаКлиенте
Процедура КД3_КонфигурацияПриИзмененииПосле(Элемент)
	ЭтотОбъект.КД3_Конфигурация = Объект.Конфигурация;
	КД3_МетаданныеКлиент.ОбновитьМетаданныеКонфигурации(ЭтотОбъект, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КД3_КонфигурацияИсточникПриИзмененииПосле(Элемент)
	ЭтотОбъект.КД3_Конфигурация = Объект.Конфигурация;
	КД3_МетаданныеКлиент.ОбновитьМетаданныеКонфигурации(ЭтотОбъект, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КД3_КонфигурацияКорреспондентПриИзмененииПосле(Элемент)
	ЭтотОбъект.КД3_КонфигурацияКорреспондент = Объект.КонфигурацияКорреспондент;
	КД3_МетаданныеКлиент.ОбновитьМетаданныеКонфигурации(ЭтотОбъект, Истина);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.СтраницаКонвертацияXDTO Тогда
		КД3_Подключаемый_ГруппаДанныеКонвертацииXDTOПриСменеСтраницы(, Элементы.ГруппаДанныеКонвертацииXDTO.ТекущаяСтраница)
	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаКонвертацияXML Тогда
		КД3_МетаданныеКлиент.ПриСменеСтраницы(ЭтотОбъект, Элементы.ОбработчикиXML.ТекущаяСтраница);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ГруппаДанныеКонвертацииXDTOПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.СтраницаОбработчики Тогда
		КД3_МетаданныеКлиент.ПриСменеСтраницы(ЭтотОбъект, Элементы.СтраницыОбработчики.ТекущаяСтраница);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ОбработчикиПриСменеСтраницы(Элемент, ТекущаяСтраница)
	КД3_МетаданныеКлиент.ПриСменеСтраницы(ЭтотОбъект, ТекущаяСтраница);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ДокументСформирован(Элемент);
	ИмяОбработчика = Сред(Элемент.Имя, 5);
	КД3_МетаданныеКлиент.ИнициализацияРедактора(ЭтотОбъект, Элемент.Имя);
	КД3_МетаданныеКлиент.УстановитьТекст(ЭтотОбъект, Элемент.Имя, Объект[ИмяОбработчика]);
	КД3_МетаданныеКлиент.ОповещатьОбИзменениях(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_HTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	КД3_МетаданныеКлиент.ОбработатьСобытиеHTML(ЭтотОбъект, Элемент, ДанныеСобытия);
КонецПроцедуры
