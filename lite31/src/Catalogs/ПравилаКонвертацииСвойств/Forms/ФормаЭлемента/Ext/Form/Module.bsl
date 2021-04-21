﻿
&НаСервере
Процедура КД3_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЭтоКонвертацияXDTO Тогда
		Обработчики = Новый СписокЗначений;
		Обработчики.Добавить("АлгоритмПередВыгрузкойСвойства");
		Обработчики.Добавить("АлгоритмПриВыгрузкеСвойства");
		Обработчики.Добавить("АлгоритмПослеВыгрузкиСвойства");
		СтраницыОбработчиков = Элементы.СтраницыОбработчики;
		КД3_Метаданные.ПриСозданииНаСервере(ЭтотОбъект, Отказ, ЭтоКонвертацияXDTO, Обработчики, СтраницыОбработчиков);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_ПриОткрытииПосле(Отказ)
	Если НЕ ЭтоКонвертацияXDTO Тогда
		КД3_СтраницыОбработчикиПриСменеСтраницыПосле(Элементы.СтраницыОбработчики, Элементы.СтраницыОбработчики.ТекущаяСтраница);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КД3_ПередЗаписьюПосле(Отказ, ПараметрыЗаписи)
	Если НЕ ЭтоКонвертацияXDTO Тогда
		КД3_МетаданныеКлиент.ПередЗаписью(ЭтотОбъект, Отказ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КД3_ПередЗакрытиемПосле(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если НЕ ЭтоКонвертацияXDTO Тогда
		КД3_МетаданныеКлиент.ПередЗаписью(ЭтотОбъект, Отказ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КД3_ГруппаXMLПриСменеСтраницыПосле(Элемент, ТекущаяСтраница)
	
	Если ЭтоКонвертацияXDTO Тогда
		Возврат;
	КонецЕсли;
	Если ТекущаяСтраница = Элементы.Обработчики Тогда
		КД3_СтраницыОбработчикиПриСменеСтраницыПосле(Элементы.СтраницыОбработчики, Элементы.СтраницыОбработчики.ТекущаяСтраница);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_СтраницыОбработчикиПриСменеСтраницыПосле(Элемент, ТекущаяСтраница)
	
	Если ЭтоКонвертацияXDTO Тогда
		Возврат;
	КонецЕсли;
	Если ТекущаяСтраница = Элементы.ПередВыгрузкой Тогда
		ИмяОбработчика = "АлгоритмПередВыгрузкойСвойства";
	ИначеЕсли ТекущаяСтраница = Элементы.ПриВыгрузке Тогда
		ИмяОбработчика = "АлгоритмПриВыгрузкеСвойства";
	ИначеЕсли ТекущаяСтраница = Элементы.ПослеВыгрузки Тогда
		ИмяОбработчика = "АлгоритмПослеВыгрузкиСвойства";
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
