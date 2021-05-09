﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Настройки = КД3_Метаданные.ЗагрузитьНастройки();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Настройки = ЗаписатьНастройкиНаСервере();
	// Сохранение настроек в клиентском кэше
	КД3_МетаданныеКлиент.СохранитьНастройкиВКэше(Настройки);
	Закрыть();
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьНастройкиНаСервере()
	
	Настройки = КД3_Метаданные.НастройкиПоУмолчанию();
	ЗаполнитьЗначенияСвойств(Настройки, ЭтотОбъект);
	КД3_Метаданные.СохранитьНастройки(Настройки);
	Возврат Настройки;
	
КонецФункции
