﻿
#Область ПодключаемыеОбработчики

&НаКлиенте
Процедура КД3_Подключаемый_ГруппаXMLПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.Обработчики Тогда
		КД3_УправлениеФормойКлиент.ПриСменеСтраницы(ЭтотОбъект, Элементы.СтраницыОбработчики.ТекущаяСтраница);
	КонецЕсли;
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура КД3_Подключаемый_ОбработчикиПриСменеСтраницы(Элемент, ТекущаяСтраница)
	КД3_УправлениеФормойКлиент.ПриСменеСтраницы(ЭтотОбъект, ТекущаяСтраница);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура КД3_Подключаемый_ПриИзмененииКонфигурации(Элемент)
	КД3_УправлениеФормойКлиент.ОчиститьМетаданныеКонфигурации(ЭтотОбъект, Ложь);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура КД3_Подключаемый_ДокументСформирован(Элемент)
	КД3_УправлениеФормойКлиент.ИнициализацияРедактора(ЭтотОбъект, Элемент.Имя, Объект);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ИнициализацияМетаданных() Экспорт
	КД3_УправлениеФормойКлиент.ИнициализацияМетаданных(ЭтотОбъект, ЭтоКонвертацияXDTO);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура КД3_Подключаемый_HTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	КД3_УправлениеФормойКлиент.ОбработатьСобытиеHTML(ЭтотОбъект, Элемент, ДанныеСобытия);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура КД3_Подключаемый_КомандаРедактора(Команда)
	КД3_УправлениеФормойКлиент.КомандаРедактора(ЭтотОбъект, Команда);
КонецПроцедуры

#КонецОбласти

#Область ЗаменяемыеОбработчики

//@skip-warning
&НаСервере
Процедура КД3_Подключаемый_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	ПриСозданииНаСервере(Отказ, СтандартнаяОбработка); // Типовой
	
	Если НЕ ЭтоКонвертацияXDTO Тогда
		Обработчики = Новый СписокЗначений;
		Обработчики.Добавить("АлгоритмПередОбработкойВыгрузки");
		Обработчики.Добавить("АлгоритмПередВыгрузкойСвойства");
		Обработчики.Добавить("АлгоритмПриВыгрузкеСвойства");
		Обработчики.Добавить("АлгоритмПослеВыгрузкиСвойства");
		Обработчики.Добавить("АлгоритмПослеОбработкиВыгрузки");
		СтраницыОбработчиков = Элементы.СтраницыОбработчики;
		КД3_УправлениеФормой.ПриСозданииНаСервере(ЭтотОбъект, Отказ, ЭтоКонвертацияXDTO, "ПКГС", Обработчики, СтраницыОбработчиков);
		
		УстановитьДействие("ПриОткрытии", "КД3_Подключаемый_ПриОткрытииПосле");
		УстановитьДействие("ПередЗаписью", "КД3_Подключаемый_ПередЗаписьюПосле");
		УстановитьДействие("ПриЗакрытии", "КД3_Подключаемый_ПриЗакрытииПосле");
		Элементы.ГруппаXML.УстановитьДействие("ПриСменеСтраницы", "КД3_Подключаемый_ГруппаXMLПриСменеСтраницы");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ПриОткрытииПосле(Отказ)
	КД3_УправлениеФормойКлиент.ПриСменеСтраницы(ЭтотОбъект, Элементы.СтраницыОбработчики.ТекущаяСтраница);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ПередЗаписьюПосле(Отказ, ПараметрыЗаписи)
	КД3_УправлениеФормойКлиент.ПередЗаписью(ЭтотОбъект, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ПриЗакрытииПосле(ЗавершениеРаботы) Экспорт
	КД3_УправлениеФормойКлиент.ПриЗакрытии(ЭтотОбъект);
КонецПроцедуры

#Если Сервер Тогда
КД3_УправлениеФормой.ПриПервомОткрытииФормы(ЭтотОбъект);
#КонецЕсли

#КонецОбласти
