﻿
&НаСервере
Процедура КД3_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Обработчики = Новый СписокЗначений;
	Обработчики.Добавить("АлгоритмПередВыгрузкойОбъекта", "BeforeUnloadingObject");
	Обработчики.Добавить("АлгоритмПриВыгрузкеОбъекта", "OnUnloadingObject");
	Обработчики.Добавить("АлгоритмПослеВыгрузкиОбъекта", "AfterUnloadingObject");
	Обработчики.Добавить("АлгоритмПослеВыгрузкиОбъектаВФайлОбмена", "AfterUploadingObjectInFileExchange");
	Обработчики.Добавить("АлгоритмПередЗагрузкойОбъекта", "BeforeLoadingObject", Истина);
	Обработчики.Добавить("АлгоритмПриЗагрузкеОбъекта", "OnLoadingObject", Истина);
	Обработчики.Добавить("АлгоритмПослеЗагрузкиОбъекта", "AfterLoadingObject", Истина);
	КД3_Метаданные.ПриСозданииНаСервере(ЭтотОбъект, Отказ, Ложь, Обработчики, Элементы.ОбработчикиXML);
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_ПриОткрытииПосле(Отказ)
	КД3_МетаданныеКлиент.ПриОткрытии(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура КД3_ПередЗаписьюПосле(Отказ, ПараметрыЗаписи)
	КД3_МетаданныеКлиент.ПередЗаписью(ЭтотОбъект, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура КД3_ПередЗакрытиемПосле(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	КД3_МетаданныеКлиент.ПередЗаписью(ЭтотОбъект, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура КД3_СтраницыПриСменеСтраницыПосле(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.ОбработчикиСобытий Тогда
		КД3_ОбработчикиXMLПриСменеСтраницыПосле(Элементы.ОбработчикиXML, Элементы.ОбработчикиXML.ТекущаяСтраница);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_ОбработчикиXMLПриСменеСтраницыПосле(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.Страница_ПередВыгрузкой Тогда
		ИмяОбработчика = "АлгоритмПередВыгрузкойОбъекта";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПриВыгрузке Тогда
		ИмяОбработчика = "АлгоритмПриВыгрузкеОбъекта";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПослеВыгрузки Тогда
		ИмяОбработчика = "АлгоритмПослеВыгрузкиОбъекта";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПослеВыгрузкиВФайл Тогда
		ИмяОбработчика = "АлгоритмПослеВыгрузкиОбъектаВФайлОбмена";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПередЗагрузкой Тогда
		ИмяОбработчика = "АлгоритмПередЗагрузкойОбъекта";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПриЗагрузке Тогда
		ИмяОбработчика = "АлгоритмПриЗагрузкеОбъекта";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПослеЗагрузки Тогда
		ИмяОбработчика = "АлгоритмПослеЗагрузкиОбъекта";
	Иначе
		Возврат;
	КонецЕсли;
	КД3_МетаданныеКлиент.ПриСменеСтраницы(ЭтотОбъект, ИмяОбработчика);
	
КонецПроцедуры

&НаСервере
&После("ОбработкаВыбораНаСервере")
Процедура КД3_ОбработкаВыбораНаСервере()
	КД3_Метаданные.ПриИзмененииКонвертаций(ЭтотОбъект, Ложь);
КонецПроцедуры

&НаСервере
&После("ДополнитьСоставКонвертации")
Процедура КД3_ДополнитьСоставКонвертации(Конвертация, ЭлементКонвертации, ОтказДобавления)
	Если НЕ ОтказДобавления Тогда
		КД3_Метаданные.ПриИзмененииКонвертаций(ЭтотОбъект, Ложь);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ПриИзмененииКонфигурации(Элемент)
	КД3_МетаданныеКлиент.ОбновитьМетаданныеКонфигурации(ЭтотОбъект, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ПриИзмененииКонфигурацииКорреспондента(Элемент)
	КД3_МетаданныеКлиент.ОбновитьМетаданныеКонфигурации(ЭтотОбъект, Истина);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ДокументСформирован(Элемент)
	ИмяОбработчика = Сред(Элемент.Имя, 5);
	КД3_МетаданныеКлиент.ИнициализацияРедактора(ЭтотОбъект, Элемент.Имя);
	КД3_МетаданныеКлиент.УстановитьТекст(ЭтотОбъект, Элемент.Имя, Объект[ИмяОбработчика]);
	КД3_МетаданныеКлиент.ОбновитьМетаданные(ЭтотОбъект, ИмяОбработчика);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_HTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	КД3_МетаданныеКлиент.ОбработатьСобытиеHTML(ЭтотОбъект, Элемент, ДанныеСобытия);
КонецПроцедуры
