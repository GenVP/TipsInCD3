﻿//The MIT License (MIT)

//Copyright (c) 2019-2023 BIA Technologies, LLC

// https://github.com/bia-technologies/bsl-parser

//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:

//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьМетодыМодуля(ДанныеМодуля, ПолноеИмяФайла, ПараметрыЗагрузки) Экспорт
	//+КД3
	СтрокаМодуля = Новый Структура("ТипМодуля,ОписаниеМодуля");
	ОписаниеМодуля = ПрочитатьМодуль(ПолноеИмяФайла, СтрокаМодуля);
	
	Для Каждого СтрокаБлока Из ОписаниеМодуля.БлокиМодуля Цикл
		// Используются только процедуры/функции
		Если СтрокаБлока.ТипБлока <> "ЗаголовокПроцедуры" И СтрокаБлока.ТипБлока <> "ЗаголовокФункции" Тогда
			Продолжить;
		КонецЕсли;
		Если НЕ СтрокаБлока.ОписаниеБлока.Экспортный Тогда
			Продолжить;
		КонецЕсли;
		
		Попытка
			ИмяМетода = СтрокаБлока.ОписаниеБлока.ИмяМетода;
			ОписаниеМетода = СтрокаБлока.ОписаниеБлока.Назначение;
			СтруктураПараметров =Новый Структура;
			Для Каждого СтрокаПараметра Из СтрокаБлока.ОписаниеБлока.ПараметрыМетода Цикл
				СтруктураПараметров.Вставить(СтрокаПараметра.Имя, СтрокаПараметра.ОписаниеПараметра);
			КонецЦикла;
			СтрокаПараметров = СтрЗаменить(СтрокаБлока.Содержимое, Символы.ПС, "");
			ПозСкобкиЛ = СтрНайти(СтрокаПараметров, "(");
			Если ПозСкобкиЛ <> 0 Тогда
				СтрокаПараметров = СокрЛ(Сред(СтрокаПараметров, ПозСкобкиЛ + 1));
			КонецЕсли;
			ПозСкобкиП = СтрНайти(СтрокаПараметров, ")", НаправлениеПоиска.СКонца);
			Если ПозСкобкиП <> 0 Тогда
				СтрокаПараметров = СокрП(Лев(СтрокаПараметров, ПозСкобкиП - 1));
			КонецЕсли;
			
			ДанныеМетода = Новый Структура;
			ДанныеМетода.Вставить("name", ИмяМетода);
			ДанныеМетода.Вставить("name_en", ИмяМетода);
			ДанныеМетода.Вставить("description", ОписаниеМетода);
			ДанныеМетода.Вставить("detail", ОписаниеМетода);
			ДанныеМетода.Вставить("returns", "");
			ДанныеМетода.Вставить("signature", Новый Структура("default", Новый Структура));
			
			ДанныеМетода.signature.default.Вставить("СтрокаПараметров", "(" + СтрокаПараметров + ")");
			ДанныеМетода.signature.default.Вставить("Параметры", СтруктураПараметров);
			
			ДанныеМодуля.module.Вставить(ИмяМетода, ДанныеМетода);
		Исключение
			//  Некорректный разбор описания/параметров метода
		КонецПопытки;
	КонецЦикла;
	
	ДанныеМодуля.count = ДанныеМодуля.module.Количество();
	//+КД3
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет чтение структуры модуля
//
// Параметры:
//   СодержимоеФайла - ТекстовыйДокумент - Код модуля
//   СтрокаМодуль - СтрокаТаблицыЗначений - Описание модуля
//
//  Возвращаемое значение:
//   Структура - Информация о структуре модуля
//		* Содержимое - Строка - Текст модуля
//		* БлокиМодуля - ТаблицаЗначений - Информация о ключевых блоках (областях, методах) модуля
//
Функция ПрочитатьМодуль(ПутьКФайлу, СтрокаМодуль) Экспорт

	СодержимоеФайла = Новый ТекстовыйДокумент;
	СодержимоеФайла.Прочитать(ПутьКФайлу, КодировкаТекста.UTF8);
	
	БлокиМодуля = Новый ТаблицаЗначений;
	БлокиМодуля.Колонки.Добавить("ТипБлока");
	БлокиМодуля.Колонки.Добавить("НачальнаяСтрока");
	БлокиМодуля.Колонки.Добавить("КонечнаяСтрока");
	БлокиМодуля.Колонки.Добавить("Содержимое");
	БлокиМодуля.Колонки.Добавить("ОписаниеБлока");

	КоличествоСтрокМодуля = СодержимоеФайла.КоличествоСтрок();
	
	ТекущийБлок = Неопределено;
	ЭтоКонецБлока = Истина;
	НовыйБлок = Неопределено;

	НачальнаяСтрока = 1;
	КонечнаяСтрока = 1;

	Для НомерСтроки = 1 По КоличествоСтрокМодуля Цикл
		
		СтрокаМодуля = ВРег(СокрЛП(СодержимоеФайла.ПолучитьСтроку(НомерСтроки)));

		ПрочитатьСтрокуМодуля(СтрокаМодуля, НовыйБлок, ТекущийБлок, ЭтоКонецБлока);

		Если НовыйБлок = ТекущийБлок Тогда
			
			КонечнаяСтрока = КонечнаяСтрока + 1;
			
		Иначе
			
			Если ЗначениеЗаполнено(ТекущийБлок) Тогда

				ЗапомнитьНовыйБлок(БлокиМодуля, ТекущийБлок, НачальнаяСтрока, КонечнаяСтрока, СодержимоеФайла);
				
			КонецЕсли;
			
			НачальнаяСтрока = НомерСтроки;
			КонечнаяСтрока  = НомерСтроки;
			ТекущийБлок 	= НовыйБлок;

		КонецЕсли;
		
		Если НомерСтроки = КоличествоСтрокМодуля Тогда

			ЗапомнитьНовыйБлок(БлокиМодуля, ТекущийБлок, НачальнаяСтрока, КонечнаяСтрока, СодержимоеФайла);

		КонецЕсли;

	КонецЦикла;

	СодержимоеМодуля = Новый Структура("Содержимое, БлокиМодуля", СодержимоеФайла.ПолучитьТекст(), БлокиМодуля);
	
	ДополнитьБлокиМодуля(БлокиМодуля, СодержимоеФайла, СтрокаМодуль);

	Возврат СодержимоеМодуля;

КонецФункции

Процедура ТипыБлоковМодуля_Инициализация()
	
	ТипыБлоковМодуля = Новый Структура;
	ТипыБлоковМодуля.Вставить("СтрокаТекста", "СтрокаТекста");
	ТипыБлоковМодуля.Вставить("ПустаяСтрока", "ПустаяСтрока");
	ТипыБлоковМодуля.Вставить("Описание", "Описание");
	
КонецПроцедуры

Функция ЭтоБлокНачалоОбласти(СтрокаМодуля) Экспорт
	Возврат СтрНачинаетсяС(СтрокаМодуля, "#ОБЛАСТЬ")
		ИЛИ СтрНачинаетсяС(СтрокаМодуля, "// #ОБЛАСТЬ");
КонецФункции

Функция ЭтоБлокКонецОбласти(СтрокаМодуля) Экспорт
	Возврат СтрНачинаетсяС(СтрокаМодуля, "#КОНЕЦОБЛАСТИ")
		ИЛИ СтрНачинаетсяС(СтрокаМодуля, "// #КОНЕЦОБЛАСТИ");
КонецФункции

Функция ЭтоБлокНачалоФункции(СтрокаМодуля) Экспорт
	Возврат СтрНачинаетсяС(СтрокаМодуля, "ФУНКЦИЯ ")
		ИЛИ СтрНачинаетсяС(СтрокаМодуля, "FUNCTION ")
		//+КД3
		ИЛИ СтрНачинаетсяС(СтрокаМодуля, "ФУНКЦИЯ" + Символы.Таб)
		ИЛИ СтрНачинаетсяС(СтрокаМодуля, "FUNCTION" + Символы.Таб);
		//-КД3
КонецФункции

Функция ЭтоБлокНачалоПроцедуры(СтрокаМодуля) Экспорт
	Возврат СтрНачинаетсяС(СтрокаМодуля, "ПРОЦЕДУРА ")
		ИЛИ СтрНачинаетсяС(СтрокаМодуля, "PROCEDURE ")
		//+КД3
		ИЛИ СтрНачинаетсяС(СтрокаМодуля, "ПРОЦЕДУРА" + Символы.Таб)
		ИЛИ СтрНачинаетсяС(СтрокаМодуля, "PROCEDURE" + Символы.Таб);
		//-КД3
КонецФункции

Функция ЭтоБлокКонецФункции(СтрокаМодуля) Экспорт
	Возврат СтрНачинаетсяС(СтрокаМодуля, "КОНЕЦФУНКЦИИ")
		ИЛИ СтрНачинаетсяС(СтрокаМодуля, "ENDFUNCTION");
КонецФункции

Функция ЭтоБлокКонецПроцедуры(СтрокаМодуля) Экспорт
	Возврат СтрНачинаетсяС(СтрокаМодуля, "КОНЕЦПРОЦЕДУРЫ")
		ИЛИ СтрНачинаетсяС(СтрокаМодуля, "ENDPROCEDURE");
КонецФункции
Функция ЭтоКонецБлокаСкобка(СтрокаМодуля)
	Возврат СтрНайти(СтрокаМодуля, ")") > 0;
КонецФункции

Функция ЭтоКонецБлокаТЗапятая(СтрокаМодуля)
	Возврат СтрНайти(СтрокаМодуля, ";") > 0;
КонецФункции

Процедура УдалитьКомментарийИзСтрокиСначала(СтрокаМодуля)
	Если СтрНачинаетсяС(СтрокаМодуля, "//") Тогда
		СтрокаМодуля = Сред(СтрокаМодуля, 4);
	КонецЕсли;
КонецПроцедуры

Процедура УдалитьКомментарийИзСтроки(СтрокаМодуля)

	ПозицияКомментария = СтрНайти(СтрокаМодуля, "//");
	Если ПозицияКомментария > 0 Тогда

		СтрокаМодуля = СокрП(Лев(СтрокаМодуля, ПозицияКомментария - 1));

	КонецЕсли;

КонецПроцедуры

Процедура ПрочитатьСтрокуМодуля(СтрокаМодуля, НовыйБлок, ТекущийБлок, ЭтоКонецБлока)
	Если НЕ ЭтоКонецБлока Тогда
		НовыйБлок = ТекущийБлок;
		Если НовыйБлок = "ОписаниеПеременной" Тогда
			УдалитьКомментарийИзСтроки(СтрокаМодуля);
			ЭтоКонецБлока = ЭтоКонецБлокаТЗапятая(СтрокаМодуля);
		ИначеЕсли НовыйБлок = "ЗаголовокПроцедуры"
				ИЛИ НовыйБлок = "ЗаголовокФункции" Тогда
			УдалитьКомментарийИзСтроки(СтрокаМодуля);
			ЭтоКонецБлока = ЭтоКонецБлокаСкобка(СтрокаМодуля);
		Иначе
			ЭтоКонецБлока = Истина;
		КонецЕсли;
	ИначеЕсли ЭтоБлокОбласти(СтрокаМодуля, НовыйБлок) Тогда
		ЭтоКонецБлока = Истина;
		УдалитьКомментарийИзСтрокиСначала(СтрокаМодуля);
	ИначеЕсли СтрНачинаетсяС(СтрокаМодуля, "//") Тогда			
		НовыйБлок = "Комментарий";
		ЭтоКонецБлока = Истина;
	ИначеЕсли СтрНачинаетсяС(СтрокаМодуля, "&") Тогда
		НовыйБлок = "ДирективаКомпиляции";
		ЭтоКонецБлока = Истина;
	ИначеЕсли СтрНачинаетсяС(СтрокаМодуля, "ПЕРЕМ") Тогда
		НовыйБлок = "ОписаниеПеременной";
		УдалитьКомментарийИзСтроки(СтрокаМодуля);
		ЭтоКонецБлока = ЭтоКонецБлокаТЗапятая(СтрокаМодуля);
	ИначеЕсли ЭтоБлокНачалоМетода(СтрокаМодуля, НовыйБлок) Тогда
		УдалитьКомментарийИзСтроки(СтрокаМодуля);
		ЭтоКонецБлока = ЭтоКонецБлокаСкобка(СтрокаМодуля);
	ИначеЕсли ЭтоБлокКонецМетода(СтрокаМодуля, НовыйБлок) Тогда
		ЭтоКонецБлока = Истина;
		УдалитьКомментарийИзСтроки(СтрокаМодуля);
	ИначеЕсли ПустаяСтрока(СтрокаМодуля) И ТекущийБлок <> "Операторы" Тогда
		НовыйБлок = "ПустаяСтрока";
		ЭтоКонецБлока = Истина;
	Иначе
		НовыйБлок = "Операторы";
		ЭтоКонецБлока = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция ЭтоБлокОбласти(СтрокаМодуля, НовыйБлок)
	Если ЭтоБлокНачалоОбласти(СтрокаМодуля) Тогда
		НовыйБлок = "НачалоОбласти";
		Возврат Истина;
	ИначеЕсли ЭтоБлокКонецОбласти(СтрокаМодуля) Тогда
		НовыйБлок = "КонецОбласти";
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

Функция ЭтоБлокНачалоМетода(СтрокаМодуля, НовыйБлок)
	//+КД3
	СтрокаПроверки = УдалитьАсинх(СтрокаМодуля);
	Если ЭтоБлокНачалоПроцедуры(СтрокаПроверки) Тогда
		НовыйБлок = "ЗаголовокПроцедуры";
		Возврат Истина;
	ИначеЕсли ЭтоБлокНачалоФункции(СтрокаПроверки) Тогда
		НовыйБлок = "ЗаголовокФункции";
		Возврат Истина;
	//-КД3
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

Функция ЭтоБлокКонецМетода(СтрокаМодуля, НовыйБлок)
	Если ЭтоБлокКонецПроцедуры(СтрокаМодуля) Тогда
		НовыйБлок = "ОкончаниеПроцедуры";
		Возврат Истина;
	ИначеЕсли ЭтоБлокКонецФункции(СтрокаМодуля) Тогда
		НовыйБлок = "ОкончаниеФункции";
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

Процедура ЗапомнитьНовыйБлок(БлокиМодуля, ТекущийБлок, НачальнаяСтрока, КонечнаяСтрока, СодержимоеФайла)
	НоваяЗаписьОБлоке = БлокиМодуля.Добавить();
	НоваяЗаписьОБлоке.ТипБлока = ТекущийБлок;
	НоваяЗаписьОБлоке.НачальнаяСтрока = НачальнаяСтрока;
	НоваяЗаписьОБлоке.КонечнаяСтрока  = КонечнаяСтрока;
	НоваяЗаписьОБлоке.ОписаниеБлока = Новый Структура;

	УдалятьКомментарии = ТекущийБлок = "ЗаголовокПроцедуры"
			ИЛИ ТекущийБлок = "ЗаголовокФункции";
	НоваяЗаписьОБлоке.Содержимое = ПолучитьСодержимоеБлока(СодержимоеФайла, НачальнаяСтрока,
			КонечнаяСтрока, УдалятьКомментарии);
КонецПроцедуры

Функция ПолучитьНазначениеБлока(Файл, Знач НачальнаяСтрока, Знач КонечнаяСтрока)

	Назначение = "";
	Если НЕ (НачальнаяСтрока + 1 < КонечнаяСтрока) Тогда
		Возврат Назначение;
	КонецЕсли;

	СтрокаМодуляНач = СокрЛП(Файл.ПолучитьСтроку(НачальнаяСтрока));
	СтрокаМодуляКон = СокрЛП(Файл.ПолучитьСтроку(КонечнаяСтрока));
	Если СтрНачинаетсяС(СтрокаМодуляНач, "////") 
			И СтрНачинаетсяС(СтрокаМодуляКон, "////") Тогда // да, это описание
		
		Для Ит = НачальнаяСтрока + 1 По КонечнаяСтрока - 1 Цикл
						
			СтрокаМодуля = СокрЛП(Сред(Файл.ПолучитьСтроку(Ит), 3));
			Назначение = Назначение + ?(ПустаяСтрока(Назначение), "", Символы.ПС) + СтрокаМодуля;
		КонецЦикла;
	КонецЕсли;

	Возврат Назначение;

КонецФункции

Функция ПолучитьПараметрыМетода(СтрокаПараметров)

	ПараметрыМетода = Новый ТаблицаЗначений;
	ПараметрыМетода.Колонки.Добавить("Имя");
	ПараметрыМетода.Колонки.Добавить("Знач");
	ПараметрыМетода.Колонки.Добавить("ЗначениеПоУмолчанию");
	ПараметрыМетода.Колонки.Добавить("ТипПараметра");
	ПараметрыМетода.Колонки.Добавить("ОписаниеПараметра");

	ДлинаСтроки = СтрДлина(СтрокаПараметров);

	Пока Истина Цикл

		Если ПустаяСтрока(СтрокаПараметров) Тогда

			Прервать;

		КонецЕсли;

		РазобратьСтрокуПараметров(СтрокаПараметров, ПараметрыМетода);

	КонецЦикла;
	
	Возврат ПараметрыМетода;

КонецФункции

Процедура РазобратьСтрокуПараметров(СтрокаПараметров, ПараметрыМетода)
	СтрокаПараметров = СокрЛП(СтрокаПараметров);
	ПараметрМетода = ПараметрыМетода.Добавить();
	ПараметрМетода.ЗНАЧ = Ложь;
	ПараметрМетода.Имя = "";
	ПараметрМетода.ЗначениеПоУмолчанию = Неопределено;
	ПараметрМетода.ТипПараметра = "";
	ПараметрМетода.ОписаниеПараметра = "";

	// отделим ЗНАЧ
	Если СтрНачинаетсяС(ВРег(СтрокаПараметров), "ЗНАЧ ") Тогда

		ПараметрМетода.ЗНАЧ = Истина;
		СтрокаПараметров = СокрЛП(Сред(СтрокаПараметров, 5));

	КонецЕсли;

	// отделим имя
	ПозицияРавно = СтрНайти(СтрокаПараметров, "=");
	ПозицияЗапятая = СтрНайти(СтрокаПараметров, ",");
		
	Если ПозицияЗапятая + ПозицияРавно = 0 Тогда
			
		//  вся строка параметр
		ПараметрМетода.Имя = СокрЛП(СтрокаПараметров);
		СтрокаПараметров = "";

	ИначеЕсли ПозицияРавно = 0 ИЛИ ПозицияРавно > ПозицияЗапятая И ПозицияЗапятая > 0 Тогда
			
		// значения по умолчанию нет        
		ПараметрМетода.Имя = СокрЛП(Лев(СтрокаПараметров, ПозицияЗапятая - 1));
		СтрокаПараметров = СокрЛП(Сред(СтрокаПараметров, ПозицияЗапятая + 1));

	Иначе // есть значение по умолчанию
			
		ПараметрМетода.Имя = СокрЛП(Лев(СтрокаПараметров, ПозицияРавно - 1));
		СтрокаПараметров = СокрЛП(Сред(СтрокаПараметров, ПозицияРавно + 1));
		ПозицияЗапятая = СтрНайти(СтрокаПараметров, ",");
		Если ПозицияЗапятая = 0 Тогда
				
			// до конца строки - это значение по умолчанию
			ПараметрМетода.ЗначениеПоУмолчанию = СтрокаПараметров;
			СтрокаПараметров = "";
			Возврат;

		КонецЕсли;

		// надо отделить значение по умолчанию от следующего параметра
		// варианты значения - число, строка, булево, Неопределено  
		ПозицияКавычки = СтрНайти(СтрокаПараметров, """");
		Если ПозицияКавычки = 0 ИЛИ ПозицияКавычки > ПозицияЗапятая Тогда

			// текущее значение по умолчанию не строковое
			ПараметрМетода.ЗначениеПоУмолчанию = СокрЛП(Лев(СтрокаПараметров, ПозицияЗапятая - 1));
			СтрокаПараметров = СокрЛП(Сред(СтрокаПараметров, ПозицияЗапятая + 1));
			Возврат;

		КонецЕсли;
					
		ПараметрМетода.ЗначениеПоУмолчанию = ПрочитатьЗначениепараметра(СтрокаПараметров);

	КонецЕсли;
		
КонецПроцедуры

Функция ПрочитатьЗначениепараметра(СтрокаПараметров)
	ЗначениеПараметра = "";
	КавычкаОткрыта = Истина;
	Пока Истина Цикл
		
		ПозицияКавычки = СтрНайти(СтрокаПараметров, """", , 2);
		КавычкаОткрыта = НЕ КавычкаОткрыта;
		ЗначениеПараметра = ЗначениеПараметра + Лев(СтрокаПараметров, ПозицияКавычки);
		СтрокаПараметров = Сред(СтрокаПараметров, ПозицияКавычки + 1);
	
		ПозицияЗапятая = СтрНайти(СтрокаПараметров, ",");
		ПозицияКавычки = СтрНайти(СтрокаПараметров, """", , 2);

		Если ПозицияКавычки = 0 ИЛИ ПозицияКавычки > ПозицияЗапятая ИЛИ НЕ КавычкаОткрыта Тогда
	
			ЗначениеПараметра = СокрЛП(ЗначениеПараметра + Лев(СтрокаПараметров, ПозицияЗапятая - 1));
			СтрокаПараметров = СокрЛП(Сред(СтрокаПараметров, ПозицияЗапятая + 1));
			Прервать;

		КонецЕсли;

	КонецЦикла;
	Возврат ЗначениеПараметра;
КонецФункции

Процедура ДополнитьБлокиМодуля(БлокиМодуля, Файл, Модуль)

	ОписаниеМодуля = НовыйОписаниеМодуля();

	НазначениеМодуляПрошли = Ложь;
	РазделОткрыт = Ложь;
	ЛокальнаяОбластьОткрыта = Ложь;
	МетодОткрыт = Ложь;

	Области = Новый Массив;

	ТекущийРаздел = "";
	ПоследнийБлокКомментария = Неопределено;
	ПоследнийБлокМетода = Неопределено;

	Для Каждого Блок Из БлокиМодуля Цикл

		Блок.ОписаниеБлока.Вставить("ЭтоРаздел", Ложь);
		Блок.ОписаниеБлока.Вставить("ИмяРаздела", "");
		Блок.ОписаниеБлока.Вставить("ИмяОбласти", "");
		Блок.ОписаниеБлока.Вставить("НазначениеРаздела", "");
		Блок.ОписаниеБлока.Вставить("ИмяМетода", "");
		Блок.ОписаниеБлока.Вставить("ПараметрыМетода", Неопределено);
		Блок.ОписаниеБлока.Вставить("Назначение", "");
		Блок.ОписаниеБлока.Вставить("Экспортный", Ложь);
		Блок.ОписаниеБлока.Вставить("ТипВозвращаемогоЗначения", "");
		Блок.ОписаниеБлока.Вставить("ОписаниеВозвращаемогоЗначения", "");
		Блок.ОписаниеБлока.Вставить("Примеры", Новый Массив);
		Блок.ОписаниеБлока.Вставить("Тело", "");

		Если Блок.ТипБлока = "ПустаяСтрока" Тогда

			Продолжить;

		КонецЕсли;

		Если Не НазначениеМодуляПрошли Тогда

			// если комментарий не первый, значит уже и нет смысла искать описания
			НазначениеМодуляПрошли = Блок.ТипБлока <> "Комментарий";

		КонецЕсли;

		Если Блок.ТипБлока = "Комментарий" Тогда

			ДополнитьИнформациейКомментария(Файл, Блок, ОписаниеМодуля, НазначениеМодуляПрошли, ПоследнийБлокКомментария);

		ИначеЕсли Блок.ТипБлока = "НачалоОбласти" Тогда

			СтрокаМодуля = СокрЛП(Файл.ПолучитьСтроку(Блок.НачальнаяСтрока));
			ИмяОбласти = СокрЛП(Сред(СтрокаМодуля, СтрДлина("#Область") + 1));

			ЭтоРаздел = ЭтоРаздел(Модуль, ИмяОбласти, РазделОткрыт, ЛокальнаяОбластьОткрыта, МетодОткрыт);

			Блок.ОписаниеБлока.Вставить("ЭтоРаздел", ЭтоРаздел);
			Блок.ОписаниеБлока.Вставить("ИмяРаздела", ТекущийРаздел);
			Блок.ОписаниеБлока.Вставить("ИмяОбласти", ТекущаяОбласть(Области));
			Блок.ОписаниеБлока.Вставить("НазначениеРаздела", "");

			Если ЭтоРаздел Тогда
				РазделОткрыт = Истина;
				ТекущийРаздел = ИмяОбласти;

				ОписаниеМодуля.Разделы.Добавить(ТекущийРаздел);
			
				// заполним описание раздела
				ДополнитьИнформациейРаздела(Файл, Блок, ПоследнийБлокКомментария);
			Иначе
				ЛокальнаяОбластьОткрыта = Истина;
				Области.Добавить(ИмяОбласти);
			КонецЕсли;

		ИначеЕсли Блок.ТипБлока = "КонецОбласти" И ЛокальнаяОбластьОткрыта Тогда
			ПоследнийБлокКомментария = Неопределено;
			Области.Удалить(Области.ВГраница());
			ЛокальнаяОбластьОткрыта = Области.Количество();
		ИначеЕсли Блок.ТипБлока = "КонецОбласти" И РазделОткрыт Тогда
			ПоследнийБлокКомментария = Неопределено;
			РазделОткрыт = Ложь;
			ТекущийРаздел = "";
		ИначеЕсли Блок.ТипБлока = "ЗаголовокПроцедуры"
				ИЛИ Блок.ТипБлока = "ЗаголовокФункции" Тогда
			
			Блок.ОписаниеБлока.Вставить("ИмяРаздела", ТекущийРаздел);
			Блок.ОписаниеБлока.Вставить("ИмяОбласти", ТекущаяОбласть(Области));

			МетодОткрыт = Истина;
			ПоследнийБлокМетода = Блок;

			// получим имя метода
			Заголовок = ЗаголовокМетода(Блок);
			
			// получим параметры метода
			ПозицияСкобки = СтрНайти(Заголовок, "(");
			ИмяМетода = Лев(Заголовок, ПозицияСкобки - 1);
			СтрокаПараметров = СокрЛП(Сред(Заголовок, ПозицияСкобки + 1));
			ПозицияСкобки = СтрНайти(СтрокаПараметров, ")", НаправлениеПоиска.СКонца);
			СтрокаПараметров = СокрЛП(Лев(СтрокаПараметров, ПозицияСкобки - 1));
			Заголовок = СокрЛП(Сред(Заголовок, СтрНайти(Заголовок, ")", НаправлениеПоиска.СКонца) + 1));
			Блок.ОписаниеБлока.Вставить("ИмяМетода", ИмяМетода);
			Блок.ОписаниеБлока.Вставить("ПараметрыМетода", ПолучитьПараметрыМетода(СтрокаПараметров));
			Блок.ОписаниеБлока.Вставить("Назначение", "");
			Блок.ОписаниеБлока.Вставить("Экспортный", СтрЗаканчиваетсяНа(ВРег(Заголовок), "ЭКСПОРТ"));
			Блок.ОписаниеБлока.Вставить("ТипВозвращаемогоЗначения", "");
			Блок.ОписаниеБлока.Вставить("ОписаниеВозвращаемогоЗначения", "");
			Блок.ОписаниеБлока.Вставить("Примеры", Новый Массив);

			// получим описание метода
			Если ПоследнийБлокКомментария = Неопределено Тогда
				Продолжить;
			КонецЕсли;

			СтрокаКомментария = Файл.ПолучитьСтроку(ПоследнийБлокКомментария.НачальнаяСтрока);
			СтрокаКомментария = СокрЛП(Сред(СтрокаКомментария, 3));

			ПоследнийБлокКомментария.ТипБлока = "Описание";

			Назначение = "";
			НомераСтрок = Новый Структура("НомерСтрокиПараметры, НомерСтрокиВозвращаемоеЗначение, НомерСтрокиПример");
			ОпределитьНомераСтрок(Файл, ПоследнийБлокКомментария, НомераСтрок, Назначение);
			
			ПолучитьПараметры(Файл, Блок, НомераСтрок, ПоследнийБлокКомментария);
			Блок.ОписаниеБлока.Вставить("ТипВозвращаемогоЗначения", ПолучитьВозвращаемоеЗначение(Файл, НомераСтрок, ПоследнийБлокКомментария));
			Блок.ОписаниеБлока.Вставить("Примеры", ПолучитьПримеры(Файл, ПоследнийБлокКомментария, НомераСтрок.НомерСтрокиПример));
			Блок.ОписаниеБлока.Вставить("Назначение", Назначение);

			ПоследнийБлокКомментария = Неопределено;

		ИначеЕсли Блок.ТипБлока = "ОкончаниеПроцедуры"
				ИЛИ Блок.ТипБлока = "ОкончаниеФункции" Тогда

			МетодОткрыт = Ложь;
			ПоследнийБлокКомментария = Неопределено;

			ПоследнийБлокМетода.ОписаниеБлока.Тело = ПолучитьСодержимоеБлока(Файл,
				ПоследнийБлокМетода.КонечнаяСтрока + 1, Блок.НачальнаяСтрока - 1);
			ПоследнийБлокМетода = Неопределено;

		Иначе

			// забываем последний комментарий-блок
			ПоследнийБлокКомментария = Неопределено;
		
		КонецЕсли;

	КонецЦикла;

	УдалитьЛишнийБлок(БлокиМодуля);
	
	Модуль.ОписаниеМодуля = ОписаниеМодуля;

КонецПроцедуры

Функция НовыйОписаниеМодуля()
	ОписаниеМодуля = Новый Структура();
	ОписаниеМодуля.Вставить("Глобальный", Ложь);
	ОписаниеМодуля.Вставить("ЕстьНазначениеМодуля", Ложь);
	ОписаниеМодуля.Вставить("Назначение", "");
	ОписаниеМодуля.Вставить("Разделы", Новый Массив());
	Возврат ОписаниеМодуля;
КонецФункции

Процедура УдалитьЛишнийБлок(БлокиМодуля)
	КоличествоБлоков = БлокиМодуля.Количество() - 1;
	Для Ит = 0 По КоличествоБлоков Цикл

		Блок = БлокиМодуля[КоличествоБлоков - Ит];
		БлокНадоУдалить = Блок.ТипБлока = "ОкончаниеПроцедуры"
			ИЛИ Блок.ТипБлока = "ОкончаниеФункции"
			ИЛИ Блок.ТипБлока = "КонецОбласти"
			ИЛИ Блок.ТипБлока = "Описание"
			ИЛИ Блок.ТипБлока = "ПустаяСтрока";
		Если БлокНадоУдалить Тогда

			БлокиМодуля.Удалить(Блок);
			
		КонецЕсли;

	КонецЦикла;
КонецПроцедуры

Функция ЭтоРаздел(Модуль, ИмяОбласти, РазделОткрыт, ЛокальнаяОбластьОткрыта, МетодОткрыт)

	РазделыОбщегоМодуля = Новый Массив;
	РазделыОбщегоМодуля.Добавить("ПрограммныйИнтерфейс");
	РазделыОбщегоМодуля.Добавить("СлужебныйПрограммныйИнтерфейс");
	РазделыОбщегоМодуля.Добавить("СлужебныеПроцедурыИФункции");
	
	РазделыМодуляМенеджера = Новый Массив;
	РазделыМодуляМенеджера.Добавить("ПрограммныйИнтерфейс");
	РазделыМодуляМенеджера.Добавить("СлужебныйПрограммныйИнтерфейс");
	РазделыМодуляМенеджера.Добавить("СлужебныеПроцедурыИФункции");
	РазделыМодуляМенеджера.Добавить("ОбработчикиСобытий");
	
	Если Модуль.ТипМодуля = "ОбщийМодуль" Тогда
		ЭтоРаздел = РазделыОбщегоМодуля.Найти(ИмяОбласти) <> Неопределено;
	ИначеЕсли Модуль.ТипМодуля = "МодульМенеджера" Тогда
		ЭтоРаздел = РазделыМодуляМенеджера.Найти(ИмяОбласти) <> Неопределено;
	Иначе
		ЭтоРаздел = Ложь;
	КонецЕсли;
		
	Если РазделОткрыт ИЛИ ЛокальнаяОбластьОткрыта ИЛИ МетодОткрыт Тогда
		// кривая структура модуля
		ЭтоРаздел = Ложь;
	КонецЕсли;

	Возврат ЭтоРаздел;

КонецФункции

Функция ТекущаяОбласть(Области)
	Если Области.Количество() Тогда
		Возврат Области[Области.ВГраница()];
	КонецЕсли;
	Возврат "";
КонецФункции

Функция ЗаголовокМетода(Блок)
	Заголовок = СтрЗаменить(Блок.Содержимое, Символы.ПС, " ");
	Заголовок = СокрЛП(СтрЗаменить(Заголовок, Символы.Таб, " "));
	//+КД3
	Заголовок = УдалитьАсинх(Заголовок);
	// Удаление ";" в конце заголовка метода
	ДлинаЗаголовка = СтрДлина(Заголовок);
	Пока Истина Цикл
		Окончание = Сред(Заголовок, ДлинаЗаголовка, 1);
		Если НЕ ПустаяСтрока(Окончание) И Окончание <> ";" Тогда
			Заголовок = Лев(Заголовок, ДлинаЗаголовка);
			Прервать;
		КонецЕсли;
		ДлинаЗаголовка = ДлинаЗаголовка - 1;
	КонецЦикла;
	//-КД3
	Если Блок.ТипБлока = "ЗаголовокПроцедуры" Тогда
		Заголовок = СокрЛП(Сред(Заголовок, СтрДлина("Процедура") + 1));
	ИначеЕсли СтрНачинаетсяС(Заголовок, "Функция") Тогда
		Заголовок = СокрЛП(Сред(Заголовок, СтрДлина("Функция") + 1));
	Иначе
		Заголовок = СокрЛП(Сред(Заголовок, СтрДлина("Function") + 1));
	КонецЕсли;
	Возврат Заголовок;
КонецФункции

Процедура ОпределитьНомераСтрок(Файл, ПоследнийБлокКомментария, НомераСтрок, Назначение)
	Для Ит = ПоследнийБлокКомментария.НачальнаяСтрока По ПоследнийБлокКомментария.КонечнаяСтрока Цикл
		СтрокаКомментария = Файл.ПолучитьСтроку(Ит);
		СтрокаКомментария = СокрЛП(Сред(СтрокаКомментария, 3));
		Если СтрНачинаетсяС(СтрокаКомментария, "Параметры:") Тогда
			НомераСтрок.НомерСтрокиПараметры = Ит;
			Прервать;
		ИначеЕсли СтрНачинаетсяС(СтрокаКомментария, "Возвращаемое значение:") Тогда
			НомераСтрок.НомерСтрокиВозвращаемоеЗначение = Ит;
			Прервать;
		ИначеЕсли СтрНачинаетсяС(СтрокаКомментария, "Примеры:") ИЛИ СтрНачинаетсяС(СтрокаКомментария, "Пример:") Тогда
			НомераСтрок.НомерСтрокиПример = Ит;
			Прервать;
		Иначе
			Назначение = Назначение + ?(ПустаяСтрока(Назначение), "", Символы.ПС) + СтрокаКомментария;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ДополнитьИнформациейКомментария(Файл, Блок, ОписаниеМодуля, НазначениеМодуляПрошли, ПоследнийБлокКомментария)
	Если НЕ НазначениеМодуляПрошли Тогда
		// первый комментарий считаем описанием модуля	
		НазначениеМодуляПрошли = Истина;
		Назначение = ПолучитьНазначениеБлока(Файл, Блок.НачальнаяСтрока, Блок.КонечнаяСтрока);

		Блок.ТипБлока = "Описание";
		ОписаниеМодуля.ЕстьНазначениеМодуля = НЕ ПустаяСтрока(Назначение);
		ОписаниеМодуля.Назначение = Назначение;
	Иначе
		ПоследнийБлокКомментария = Блок;
	КонецЕсли;
КонецПроцедуры

Процедура ДополнитьИнформациейРаздела(Файл, Блок, ПоследнийБлокКомментария)
	Если ПоследнийБлокКомментария <> Неопределено Тогда

		Назначение = ПолучитьНазначениеБлока(Файл, ПоследнийБлокКомментария.НачальнаяСтрока,
			ПоследнийБлокКомментария.КонечнаяСтрока);
		Блок.ОписаниеБлока.Вставить("НазначениеРаздела", Назначение);
		Если НЕ ПустаяСтрока(Назначение) Тогда
				
			ПоследнийБлокКомментария.ТипБлока = "Описание";

		КонецЕсли;

		ПоследнийБлокКомментария = Неопределено;

	КонецЕсли;
КонецПроцедуры

Функция ПолучитьСодержимоеБлока(Текст, НачальнаяСтрока, КонечнаяСтрока, УдалятьКомментарии = Ложь)
	Строки = Новый Массив();

	Для Ит = НачальнаяСтрока По КонечнаяСтрока Цикл
		СтрокаМодуля = Текст.ПолучитьСтроку(Ит);
		Если УдалятьКомментарии Тогда
			УдалитьКомментарийИзСтроки(СтрокаМодуля);
		КонецЕсли;
		
		Строки.Добавить(СтрокаМодуля);
	КонецЦикла;
	
	Возврат СтрСоединить(Строки, Символы.ПС);
КонецФункции

Функция ПолучитьПримеры(Файл, ПоследнийБлокКомментария, НомерСтрокиПример)
	Примеры = Новый Массив;
	Если НомерСтрокиПример = Неопределено Тогда
		Возврат Примеры;
	КонецЕсли;

	СтрокаПример = Новый Массив();
	Для Ит = НомерСтрокиПример + 1 По ПоследнийБлокКомментария.КонечнаяСтрока Цикл
		СтрокаКомментария = Файл.ПолучитьСтроку(Ит);
		СтрокаКомментария = СокрЛП(Сред(СтрокаКомментария, 3));
			
		Если СтрНачинаетсяС(СтрокаКомментария, "Пример") Тогда
			Примеры.Добавить(СтрСоединить(СтрокаПример, Символы.ПС));
			СтрокаПример.Очистить();
		ИначеЕсли Не ПустаяСтрока(СтрокаКомментария) Тогда
			СтрокаПример.Добавить(СтрокаКомментария);
		КонецЕсли;

	КонецЦикла;

	Если СтрокаПример.Количество() Тогда
		Примеры.Добавить(СтрСоединить(СтрокаПример, Символы.ПС));
	КонецЕсли;

	Возврат Примеры;
КонецФункции

Функция ПолучитьВозвращаемоеЗначение(Файл, НомераСтрок, ПоследнийБлокКомментария)
	ВозвращаемоеЗначение = Новый Массив();
	Если НомераСтрок.НомерСтрокиВозвращаемоеЗначение = Неопределено Тогда
		Возврат ВозвращаемоеЗначение;
	КонецЕсли;

	ОписаниеПараметра = "";
	РежимНесколькоТипов = Неопределено;
	
	ТекущийТип = Неопределено;
	Для Ит = НомераСтрок.НомерСтрокиВозвращаемоеЗначение + 1 По ПоследнийБлокКомментария.КонечнаяСтрока Цикл
		СтрокаКомментария = Файл.ПолучитьСтроку(Ит);
		СтрокаКомментария = СокрЛП(Сред(СтрокаКомментария, 3));
			
		Если СтрНачинаетсяС(СтрокаКомментария, "Пример") Тогда
			НомераСтрок.НомерСтрокиПример = Ит;
			Прервать;
		КонецЕсли;

		// 'Тип' - 'Описание'
		// 'продолжение описания'
		// или 
		//  - 'Тип' - 'Описание'
		// 'продолжение описания'
		//  - 'Тип2' - 'Описание'
		// 'продолжение описания'
					
		Если РежимНесколькоТипов = Неопределено Тогда
			РежимНесколькоТипов = СтрНачинаетсяС(СтрокаКомментария, "- ");
		КонецЕсли;

		Если НЕ РежимНесколькоТипов Тогда
			СоставСтрокиКомментария = СтрРазделить(СтрокаКомментария, "-");

			Если ТекущийТип = Неопределено Тогда
				// это описание параметра
				ТекущийТип = Новый Структура("ТипПараметра, ОписаниеПараметра", СокрЛП(СоставСтрокиКомментария[0]), Новый Массив());
				ПозицияДефис = СтрНайти(СтрокаКомментария, "-");
				Если ПозицияДефис Тогда
					ТекущийТип.ОписаниеПараметра.Добавить(СокрЛП(Сред(СтрокаКомментария, ПозицияДефис + 1)));
				Иначе
					ТекущийТип.ОписаниеПараметра.Добавить(" ");
				КонецЕсли;
			Иначе
				// продолжение описания параметра либо косячное описание
				ТекущийТип.ОписаниеПараметра.Добавить(СтрокаКомментария);
			КонецЕсли;

		ИначеЕсли СтрНачинаетсяС(СтрокаКомментария, "- ") Тогда
			ТекущийТип = ЗафиксироватьТипВозврЗначения(ВозвращаемоеЗначение, ТекущийТип);
			СоставСтрокиКомментария = СтрРазделить(СтрокаКомментария, "-");
			ТекущийТип.ТипПараметра = СокрЛП(СоставСтрокиКомментария[1]);
			Если СоставСтрокиКомментария.Количество() > 2 Тогда
				СоставСтрокиКомментария.Удалить(0);
				СоставСтрокиКомментария.Удалить(0);
				ТекущийТип.ОписаниеПараметра.Добавить(СтрСоединить(СоставСтрокиКомментария, "-"));
			Иначе
				ТекущийТип.ОписаниеПараметра.Добавить(" ");
			КонецЕсли;
		ИначеЕсли ТекущийТип <> Неопределено Тогда
			Если ТекущийТип.ОписаниеПараметра.Количество() = 0 Тогда
				ТекущийТип.ОписаниеПараметра.Добавить(" ");
			КонецЕсли;
			ТекущийТип.ОписаниеПараметра.Добавить(СтрокаКомментария);
		Иначе
			ТекущийТип = ЗафиксироватьТипВозврЗначения();
			ТекущийТип.ОписаниеПараметра.Добавить(СтрокаКомментария);
		КонецЕсли;
		
	КонецЦикла;

	ЗафиксироватьТипВозврЗначения(ВозвращаемоеЗначение, ТекущийТип);
	Возврат ВозвращаемоеЗначение;

КонецФункции

Процедура ПолучитьПараметры(Файл, Блок, НомераСтрок, ПоследнийБлокКомментария)
	Если НомераСтрок.НомерСтрокиПараметры = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ИмяПараметра = Неопределено;
	ОписаниеПараметра = "";
	ТипПараметра = "";
	Дочитывание = Ложь;
	ПрошлаяСтрока = "";
	Для Ит = НомераСтрок.НомерСтрокиПараметры + 1 По ПоследнийБлокКомментария.КонечнаяСтрока Цикл

		СтрокаКомментария = Файл.ПолучитьСтроку(Ит);
		СтрокаКомментария = СокрЛП(Сред(СтрокаКомментария, 3));
		Если СтрНачинаетсяС(СтрокаКомментария, "Возвращаемое значение:") Тогда
			НомераСтрок.НомерСтрокиВозвращаемоеЗначение = Ит;
			Прервать;
		ИначеЕсли СтрНачинаетсяС(СтрокаКомментария, "Примеры:") ИЛИ СтрНачинаетсяС(СтрокаКомментария, "Пример:") Тогда
			НомераСтрок.НомерСтрокиПример = Ит;
			Прервать;
		КонецЕсли;
						
		Если Дочитывание Тогда
			СтрокаКомментария = ПрошлаяСтрока + СтрокаКомментария;
			ПрошлаяСтрока = "";
			Дочитывание = Ложь;
		КонецЕсли;

		// шаблон параметра 
		// 'Имя' - 'Тип' - 'Описание'
		// 'продолжение описания'
		СоставСтрокиКомментария = СтрРазделить(СтрокаКомментария, "-");
		Если СоставСтрокиКомментария.Количество() = 2 И СтрЗаканчиваетсяНа(СокрЛП(СоставСтрокиКомментария[1]), ",") Тогда
			// шаблон параметра 
			// 'Имя' - 'Тип','Тип', 
			//			'Тип'  - 'Описание'
			// 'продолжение описания'
			ПрошлаяСтрока = СтрокаКомментария;
			Дочитывание = Истина;
		ИначеЕсли СоставСтрокиКомментария.Количество() >= 2 Тогда
			Если ИмяПараметра <> Неопределено Тогда
				СтрокаПараметраМетода = Блок.ОписаниеБлока.ПараметрыМетода.Найти(ИмяПараметра, "Имя");
				Если СтрокаПараметраМетода <> Неопределено Тогда
					СтрокаПараметраМетода.ТипПараметра = ТипПараметра;
					СтрокаПараметраМетода.ОписаниеПараметра = ОписаниеПараметра;
				КонецЕсли;
			КонецЕсли;

			// это описание параметра
			ИмяПараметра = СокрЛП(СоставСтрокиКомментария[0]);
			ТипПараметра = СокрЛП(СоставСтрокиКомментария[1]);
			
			Если СоставСтрокиКомментария.Количество() > 2 Тогда
				ПозицияДефис = СтрНайти(СтрокаКомментария, "-");
				ПозицияДефис = СтрНайти(СтрокаКомментария, "-", , ПозицияДефис + 1);
				ОписаниеПараметра = СокрЛП(Сред(СтрокаКомментария, ПозицияДефис + 1));
			КонецЕсли;
				
		Иначе

			// продолжение описания параметра либо косячное описание
			ОписаниеПараметра = ОписаниеПараметра + ?(ПустаяСтрока(ОписаниеПараметра), "", Символы.ПС) + СтрокаКомментария;
		КонецЕсли;

	КонецЦикла;

	Если ИмяПараметра <> Неопределено Тогда
		СтрокаПараметраМетода = Блок.ОписаниеБлока.ПараметрыМетода.Найти(ИмяПараметра, "Имя");
		Если СтрокаПараметраМетода <> Неопределено Тогда
			СтрокаПараметраМетода.ТипПараметра = ТипПараметра;
			СтрокаПараметраМетода.ОписаниеПараметра = ОписаниеПараметра;
		КонецЕсли;
	КонецЕсли;
	 
КонецПроцедуры

Функция ЗафиксироватьТипВозврЗначения(ВозвращаемоеЗначение = Неопределено, ТекущийТип = Неопределено)
	Если ТекущийТип <> Неопределено Тогда
		ТекущийТип.ОписаниеПараметра = СтрСоединить(ТекущийТип.ОписаниеПараметра, Символы.ПС);
		ВозвращаемоеЗначение.Добавить(ТекущийТип);
	КонецЕсли;
	Возврат Новый Структура("ТипПараметра, ОписаниеПараметра", "", Новый Массив());
КонецФункции
//+КД3
Функция УдалитьАсинх(СтрокаМодуля)
	
	СтрокаПроверки = ВРег(Лев(СтрокаМодуля, 6));
	Если СтрокаПроверки = "АСИНХ "
	 ИЛИ СтрокаПроверки = "ASYNC "
	 ИЛИ СтрокаПроверки = "АСИНХ" + Символы.Таб
	 ИЛИ СтрокаПроверки = "ASYNC" + Символы.Таб Тогда
		Результат = СокрЛ(Сред(СтрокаМодуля, 7));
	Иначе
		Результат = СтрокаМодуля;
	КонецЕсли;
	Возврат Результат;
	
КонецФункции
//-КД3

#КонецОбласти