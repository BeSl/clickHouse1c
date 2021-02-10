﻿
#Область ОписаниеПеременных

#КонецОбласти

#Область ПрограммныйИнтерфейс
Функция ШаблоныОпераций() Экспорт
	
	ОперацииБД = Новый Соответствие;
	ОперацииБД.Вставить("Выборка данных", "SELECT %ИменаКолонок% FROM %ИмяБД%.%ИмяТаблицы% %ФорматДанных%");
	ОперацииБД.Вставить("Вставка данных", "INSERT  INTO %ИмяБД%.%ИмяТаблицы% VALUES(%ЗначенияВставки%");
	ОперацииБД.Вставить("Создать таблицу", "CREATE TABLE %ИмяБД%.%ИмяТаблицы% (%КолонкиТипыТаблицы%)");
	ОперацииБД.Вставить("Создать Базу Данных", "CREATE DATABASE %ИмяБД% [ENGINE = %ТипБазы%]");
	
	Возврат ОперацииБД;
	
КонецФункции

Функция РеализованныеОперации() Экспорт
	
	Операции_CH = Новый Массив;
	
	Для каждого Операция из ШаблоныОпераций() Цикл
		Операции_CH.Добавить(Операция.Ключ);
	КонецЦикла;
	
	Возврат Операции_CH;
	
КонецФункции

Функция Запрос_CH(ПараметрыПодключения, ТекстЗапроса, ТипЗапроса) Экспорт
	
	HTTPСоеднинениеCH = ИнициализироватьHTTPСоединение(ПараметрыПодключения);
	ОтветПоЗапросу = Новый Структура("КодСостояния, ТелоОтвета", 400, "");
	
	Если ТипЗапроса = "get" Тогда
		Ответ = getЗапрос(HTTPСоеднинениеCH, ТекстЗапроса);
	ИначеЕсли ТипЗапроса = "post" Тогда
		Ответ = postЗапрос(HTTPСоеднинениеCH, ТекстЗапроса);
	Иначе
		ВызватьИсключение "Вызван неизвестный тип запроса";
	КонецЕсли;
	
	ОтветПоЗапросу.КодСостояния = Ответ.КодСостояния;
	ОтветПоЗапросу.ТелоОтвета = Ответ.ПолучитьТелоКакСтроку();
		
	Возврат ОтветПоЗапросу;
	
КонецФункции

Функция ТипыДанныхСтолбцов() Экспорт
	
	Возврат ТипыДанныхДляСтолбцовТаблиц();
	
КонецФункции

Функция ПараметрыЗапроса(ВариантЗапроса) Экспорт
	
	ПараметрыПоВариантуЗапроса = Новый Массив;
	
	Если ВариантЗапроса = "Создать Базу Данных" Тогда
		
		Для каждого тПараметр из ДвижкиБазДанных() Цикл
			ПараметрыПоВариантуЗапроса.Добавить(СтрШаблон("%1(%2)",тПараметр.Ключ, тПараметр.Значение));
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ПараметрыПоВариантуЗапроса;
	
КонецФункции

Функция ДвижкиБазДанных() Экспорт
	
	Движки = Новый Соответствие;
	Движки.Вставить("%ТипБазы% - MySQL", "'host:port', ['database' | database], 'user', 'password'");
	Движки.Вставить("%ТипБазы% - Lazy","%expiration_time_in_seconds%");
	
	Возврат Движки;
	
КонецФункции

#Область СправочнаяИнформацияПодсказки
Функция ВстроенныеТипыClickHouse() Экспорт
	
КонецФункции
#КонецОбласти

Функция ВыполнитьПроизвольныйЗапрос(ПараметрыПодключения, ТекстЗапроса, ТипЗапроса) Экспорт
	
	Возврат Запрос_CH(ПараметрыПодключения, ТекстЗапроса, ТипЗапроса);
	
КонецФункции

Функция ЗапросСписокВсехБД(ПараметрыПодключения) Экспорт
	
	ТекстЗапроса = "SHOW DATABASES Format JSON";
	РезультатЗапроса = Запрос_CH(ПараметрыПодключения, ТекстЗапроса, "post");
	
	Если РезультатЗапроса.КодСостояния = 200 Тогда
		Возврат РезультатЗапроса.ТелоОтвета;
	КонецЕсли;
	
	Сообщить("Ошибка Код "+РезультатЗапроса.КодСостояния);
	Возврат РезультатЗапроса.ТелоОтвета;
	
КонецФункции

Функция ЗапросСписокТаблицБД(ПараметрыПодключения, ИмяБД) Экспорт
	
	ТекстЗапроса = СтрШаблон("SHOW TABLES FROM %1 FORMAT JSON", ИмяБД);
	РезультатЗапроса = Запрос_CH(ПараметрыПодключения, ТекстЗапроса, "post");
	
	Если РезультатЗапроса.КодСостояния = 200 Тогда
		Возврат РезультатЗапроса.ТелоОтвета;
	КонецЕсли;
	
	Сообщить("Ошибка Код "+РезультатЗапроса.КодСостояния);
	Возврат РезультатЗапроса.ТелоОтвета;
	
КонецФункции
#КонецОбласти

#Область ОбработчикиСобытий
// Код процедур и функций
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
Функция ТипыДанныхДляСтолбцовТаблиц()
	
	ТипыДанныхКХ = Новый Массив;
	ТипыДанныхКХ.Добавить("UInt8"); 
	ТипыДанныхКХ.Добавить("UInt16"); 
	ТипыДанныхКХ.Добавить("UInt32"); 
	ТипыДанныхКХ.Добавить("UInt64"); 
	ТипыДанныхКХ.Добавить("Int8"); 
	ТипыДанныхКХ.Добавить("Int16"); 
	ТипыДанныхКХ.Добавить("Int32"); 
	ТипыДанныхКХ.Добавить("Int64");
	ТипыДанныхКХ.Добавить("Float32"); 
	ТипыДанныхКХ.Добавить("Float64");
	ТипыДанныхКХ.Добавить("Decimal");
	ТипыДанныхКХ.Добавить("Boolean");
	ТипыДанныхКХ.Добавить("String");
	ТипыДанныхКХ.Добавить("FixedString(N)");
	ТипыДанныхКХ.Добавить("UUID");
	ТипыДанныхКХ.Добавить("Date");
	ТипыДанныхКХ.Добавить("DateTime");
	ТипыДанныхКХ.Добавить("DateTime64");
	ТипыДанныхКХ.Добавить("Enum");
	ТипыДанныхКХ.Добавить("LowCardinality");
	ТипыДанныхКХ.Добавить("Array(T)");
	ТипыДанныхКХ.Добавить("Nullable");
	ТипыДанныхКХ.Добавить("SimpleAggregateFunction");	
	
	Возврат ТипыДанныхКХ;	
	
КонецФункции
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ИнициализироватьHTTPСоединение(ПараметрыПодключения)
	
	АдресСервера = "";
	Порт = "";
	Логин = "";
	Пароль = "";
	
	ПараметрыПодключения.Свойство("АдресСервера", АдресСервера);
	ПараметрыПодключения.Свойство("Порт", Порт);
	ПараметрыПодключения.Свойство("Логин", Логин);
	ПараметрыПодключения.Свойство("Пароль", Пароль);
	Возврат Новый HTTPСоединение(АдресСервера, Порт, Логин, Пароль);
	
КонецФункции

Функция getЗапрос(HTTPСоединениеClickHouse, ТекстЗапроса) 
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("X-ClickHouse-User", "user1");
	Заголовки.Вставить("X-ClickHouse-Key", "<password>");
	
	HTTPЗапросВнБД = Новый HTTPЗапрос("?query=" + ТекстЗапроса, Заголовки);
	HTTPОтветВнБД = HTTPСоединениеClickHouse.Получить(HTTPЗапросВнБД);
	
	Возврат HTTPОтветВнБД;	
	
КонецФункции

Функция postЗапрос(ПодключениеClickHouse, ТекстЗапроса) 
										   
	ИмяВремФайла = ПолучитьИмяВременногоФайла();
	ФайлЗапрос = Новый ТекстовыйДокумент();
	ФайлЗапрос.УстановитьТекст(ТекстЗапроса);
	ФайлЗапрос.Записать(ИмяВремФайла, КодировкаТекста.UTF8);
	
	HTTPЗапросВнБД = Новый HTTPЗапрос();
	HTTPЗапросВнБД.УстановитьИмяФайлаТела(ИмяВремФайла);
	
	HTTPОтветВнБД = ПодключениеClickHouse.ОтправитьДляОбработки(HTTPЗапросВнБД);
	
	Возврат HTTPОтветВнБД;
	
КонецФункции



#КонецОбласти

#Область Инициализация

#КонецОбласти