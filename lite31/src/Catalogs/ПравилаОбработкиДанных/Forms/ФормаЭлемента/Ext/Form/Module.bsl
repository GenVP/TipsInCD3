﻿
&НаСервере
Процедура КД3_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Обработчики = Новый СписокЗначений;
	Если КонвертацияXDTO Тогда
		Обработчики.Добавить("АлгоритмПриОбработке");
		Обработчики.Добавить("АлгоритмВыборкаДанных");
		СтраницыОбработчиков = Элементы.СтраницыОбработчикиXDTO;
	Иначе
		Обработчики.Добавить("АлгоритмПередОбработкойПравила");
		Обработчики.Добавить("АлгоритмПередВыгрузкойОбъекта");
		Обработчики.Добавить("АлгоритмПослеВыгрузкиОбъекта");
		Обработчики.Добавить("АлгоритмПослеОбработкиПравила");
		СтраницыОбработчиков = Элементы.СтраницыОбработчикиXML;
	КонецЕсли;
	КД3_Метаданные.ПриСозданииНаСервере(ЭтотОбъект, Отказ, КонвертацияXDTO, Обработчики, СтраницыОбработчиков);
	
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
	
	Если ТекущаяСтраница = Элементы.ОбработчикиСобытийXDTO Тогда
		КД3_СтраницыОбработчикиXDTOПриСменеСтраницыПосле(Элементы.СтраницыОбработчикиXDTO, Элементы.СтраницыОбработчикиXDTO.ТекущаяСтраница);
	ИначеЕсли ТекущаяСтраница = Элементы.ОбработчикиСобытийXML Тогда
		КД3_СтраницыОбработчикиXMLПриСменеСтраницыПосле(Элементы.СтраницыОбработчикиXML, Элементы.СтраницыОбработчикиXML.ТекущаяСтраница);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_СтраницыОбработчикиXDTOПриСменеСтраницыПосле(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.Страница_ПриОбработке Тогда
		ИмяОбработчика = "АлгоритмПриОбработке";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ВыборкаДанных Тогда
		ИмяОбработчика = "АлгоритмВыборкаДанных";
	Иначе
		Возврат;
	КонецЕсли;
	КД3_МетаданныеКлиент.ПриСменеСтраницы(ЭтотОбъект, ИмяОбработчика);
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_СтраницыОбработчикиXMLПриСменеСтраницыПосле(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.ПередОбработкой Тогда
		ИмяОбработчика = "АлгоритмПередОбработкойПравила";
	ИначеЕсли ТекущаяСтраница = Элементы.ПередВыгрузкой Тогда
		ИмяОбработчика = "АлгоритмПередВыгрузкойОбъекта";
	ИначеЕсли ТекущаяСтраница = Элементы.ПослеВыгрузки Тогда
		ИмяОбработчика = "АлгоритмПослеВыгрузкиОбъекта";
	ИначеЕсли ТекущаяСтраница = Элементы.ПослеОбработки Тогда
		ИмяОбработчика = "АлгоритмПослеОбработкиПравила";
	Иначе
		Возврат;
	КонецЕсли;
	КД3_МетаданныеКлиент.ПриСменеСтраницы(ЭтотОбъект, ИмяОбработчика);
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ДокументСформирован(Элемент)
	ИмяОбработчика = Сред(Элемент.Имя, 5);
	КД3_МетаданныеКлиент.ИнициализацияРедактора(ЭтотОбъект, Элемент.Имя);
	КД3_МетаданныеКлиент.УстановитьТекст(ЭтотОбъект, Элемент.Имя, Объект[ИмяОбработчика]);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_HTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	КД3_МетаданныеКлиент.ОбработатьСобытиеHTML(ЭтотОбъект, Элемент, ДанныеСобытия);
КонецПроцедуры
