﻿Перем ПараметрыПриложения Экспорт;

&После("ПередНачаломРаботыСистемы")
Процедура КД3_ПередНачаломРаботыСистемы(Отказ)
	ПараметрыПриложения = Новый Соответствие;
	КД3_НастройкиКлиент.ПередНачаломРаботыСистемы();
КонецПроцедуры

&После("ПриЗавершенииРаботыСистемы")
Процедура КД3_ПриЗавершенииРаботыСистемы()
	КД3_НастройкиКлиент.ПередЗавершениемРаботыСистемы();
КонецПроцедуры
