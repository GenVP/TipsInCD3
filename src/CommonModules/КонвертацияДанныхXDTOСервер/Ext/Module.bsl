﻿
&Вместо("ЗагрузитьСтруктуруМетаданныхПоРегламентномуЗаданию")
Процедура КД3_ЗагрузитьСтруктуруМетаданныхПоРегламентномуЗаданию(УИДРелизаСтрокой)
	
	//+КД3
	НастройкиКонфигурации = Неопределено;
	Если КД3_Настройки.ИспользоватьКонтекстнуюПодсказку() Тогда
		Если ЗначениеЗаполнено(УИДРелизаСтрокой) Тогда
			Релиз = Справочники.Релизы.ПолучитьСсылку(Новый УникальныйИдентификатор(УИДРелизаСтрокой));
			Если ОбщегоНазначения.СсылкаСуществует(Релиз) Тогда
				НастройкиКонфигурации = КД3_Метаданные.НастройкиКонфигурации(Релиз);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если НастройкиКонфигурации = Неопределено ИЛИ НастройкиКонфигурации.МестоХраненияИндексов = 0 Тогда
		// Загрузка данных контекстной подсказки для этой конфигурации не выполняется
		ПродолжитьВызов(УИДРелизаСтрокой); // Типовой обработчик
		Возврат;
	КонецЕсли;
	//-КД3
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ЗагрузкаМетаданных);
	
	ПараметрыЗагрузки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Релиз, "ИсточникДанных, КаталогЗагрузки, РегламентноеЗаданиеGUID, ВариантЗагрузкиДвижений, ЕстьРасширения");
	Если ПараметрыЗагрузки.ИсточникДанных = 1 Тогда
		Результат = Неопределено;
		Попытка
			Результат = ПолучитьФайлыИзGIT(Релиз);
		Исключение
			Результат = Неопределено;
		КонецПопытки;
		Если ЗначениеЗаполнено(Результат) И ТипЗнч(Результат) = Тип("Число") Тогда
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не удалось выполнить клонирование ветки из GIT репозитория. Код ошибки:'") + Результат);
		КонецЕсли; 
	ИначеЕсли ПараметрыЗагрузки.ЕстьРасширения Тогда
		КаталогиРасширений = Релиз.Расширения.Выгрузить().ВыгрузитьКолонку("ИмяКаталогаЗагрузки");
		Если КаталогиРасширений.Количество() > 0 Тогда
			ПараметрыЗагрузки.Вставить("КаталогиРасширений", КаталогиРасширений);
		Иначе
			ПараметрыЗагрузки.ЕстьРасширения = Ложь;
		КонецЕсли;
	КонецЕсли;
	ПараметрыЗагрузки.Вставить("СпособЗагрузки", 1);
	ПараметрыЗагрузки.Вставить("Конфигурация", Релиз);
	ПараметрыЗагрузки.Вставить("ТолькоОбновитьПланыОбмена", Ложь);
	ПараметрыЗагрузки.Вставить("ТолькоДобавлятьНовые", Ложь);
	
	//+КД3
	НастройкиКонфигурации = КД3_Метаданные.НастройкиКонфигурации(Релиз);
	
	ПараметрыЗагрузки.Вставить("КД3_ЭтоСервер", Истина);
	ПараметрыЗагрузки.Вставить("КД3_ИспользоватьКонтекстнуюПодсказку", Истина);
	ПараметрыЗагрузки.Вставить("КД3_МестоХраненияИндексов", НастройкиКонфигурации.МестоХраненияИндексов);
	ПараметрыЗагрузки.Вставить("КД3_КаталогИндексов", НастройкиКонфигурации.КаталогИндексов);
	ПараметрыЗагрузки.Вставить("КД3_ЗагружатьМетодыМодулей", НастройкиКонфигурации.ЗагружатьМетодыМодулей);
	ПараметрыЗагрузки.Вставить("КД3_СохранитьКаталогДляКонфигурации", Ложь);
	
	КД3_ЗагрузкаМетаданныхКлиентСервер.ПодготовитьФайлыДляЗагрузки(ПараметрыЗагрузки);
	
	ПараметрыЗагрузки.Вставить("КД3_КоличествоПотоков", 1); // Изменить на нужное количество !!!
	
	Обработки.КД3_ЗагрузкаСтруктурыКонфигурацииИзФайловXMLМногопоточно.ВыполнитьЗагрузкуМетаданных(ПараметрыЗагрузки, Неопределено);
	//-КД3
КонецПроцедуры
