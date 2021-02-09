﻿#Область СамоВзаимодействие
Процедура СоздатьБазуДанныхВСУБД(ПараметрыПодключения)
	
	ТекстЗапроса = СтрШаблон("CREATE DATABASE %1 ENGINE = MergeTree", ИмяБД);
	Заголовки = Новый Соответствие; 
	Заголовки.Вставить("query", ТекстЗапроса);
	
	ВыполнитьЗапросВБД(Заголовки);
КонецПроцедуры

Процедура ПроверитьПодключениеКБазе(ПараметрыПодключения)
	
	HTTPСоеднинениеВнБД = Новый HTTPСоединение(ПараметрыПодключения.АдресСервера, 
										   ПараметрыПодключения.Порт,
										   ПараметрыПодключения.Логин,
										   ПараметрыПодключения.Пароль);
	КомандаПроверки = "ping";
	HTTPЗапросВнБД = Новый HTTPЗапрос(КомандаПроверки);
	
	HTTPОтветВнБД = HTTPСоеднинениеВнБД.Получить(HTTPЗапросВнБД);
	
	Если HTTPОтветВнБД.КодСостояния = 200 Тогда
		РезультатЗапроса = HTTPОтветВнБД.ПолучитьТелоКакСтроку();
		Сообщить(РезультатЗапроса);
	КонецЕсли;
	
КонецПроцедуры


Процедура СоздатьТаблицуВСУБД(ПараметрыПодключения, ИмяТаблицы, ИзмеренияТаблицы)
	
	СтрокаПараметров = СтрШаблон("CREATE TABLE %1.%2 (id UInt8, demoStroka VARCHAR)", ИмяБД, "");	
	Заголовки = Новый Соответствие; 
	Заголовки.Вставить("query", СтрокаПараметров);
	ВыполнитьЗапросВБД(Заголовки);
	
КонецПроцедуры

Процедура ТестовыйЗапрос(ПараметрыПодключения)
	
	HTTPСоеднинениеВнБД = Новый HTTPСоединение(ПараметрыПодключения.АдресСервера, 
										   ПараметрыПодключения.Порт,
										   ПараметрыПодключения.Логин,
										   ПараметрыПодключения.Пароль);
										   
	
	СтрокаПараметров = "?query=Select 1;";
	СтрокаПараметров = "?query=SHOW DATABASES";
	HTTPЗапросВнБД = Новый HTTPЗапрос(СтрокаПараметров);
	HTTPОтветВнБД = HTTPСоеднинениеВнБД.Получить(HTTPЗапросВнБД);
	РезультатЗапроса = Неопределено;
	РезультатЗапроса = HTTPОтветВнБД.ПолучитьТелоКакСтроку();
	Сообщить("КодСостояния " +HTTPОтветВнБД.КодСостояния);
	Сообщить(РезультатЗапроса);	
КонецПроцедуры
Процедура ВставкаДанныхВТаблицу(ПараметрыПодключения)
	
	СтрокаПараметров = СтрШаблон("INSERT  INTO %3.%4 VALUES(%1, %2);", "", "", ИмяБД, "");
	//СтрокаПараметров = "INSERT INTO myDB.myTab Values('2021-01-15', '2021-02-21','й\=11s','03ww')";	
	
	ВыполнитьЗапросВБД(СтрокаПараметров, "query");
	
КонецПроцедуры
Процедура ВыборкаДанныхИЗСУБД(ПараметрыПодключения)
//	 ТекстЗапросаВыборки = "SHOW DATABASES";
	ОтветОтБД = ЗапросВыборки("?query=" + ТекстЗапросаВыборки);
	Сообщить(ОтветОтБД);
	
КонецПроцедуры
Процедура СгенерироватьШаблонЗапросаВыбрать()
	
	БазовыйШаблон = "SELECT * FROM %1.%2";
	
	Если ЗначениеЗаполнено(ФорматПринимаемыхДанных) Тогда
		ДобавкаФормата = " FORMAT "+ФорматПринимаемыхДанных;
		БазовыйШаблон = БазовыйШаблон + ДобавкаФормата;
	КонецЕсли;
	
	ТекстЗапросаВыборки = СтрШаблон(БазовыйШаблон, ИмяБД, "");
	
КонецПроцедуры
#КонецОбласти

#Область МетодыПомощники

Функция ПараметрыПодключенияПоУмолчанию()
	
	ПараметрыПодключения = Новый Структура;
	ПараметрыПодключения.Вставить("АдресСервера", "192.168.1.102");
	ПараметрыПодключения.Вставить("Порт", 8123);
	ПараметрыПодключения.Вставить("Логин", "default");
	//ПараметрыПодключения.Вставить("Пароль", "");	
	
	Возврат ПараметрыПодключения;
	
КонецФункции

Функция ЗапросВыборки(ТекстЗапроса)
	HTTPСоеднинениеВнБД = Новый HTTPСоединение(АдресСервера, Порт,  Логин, Пароль);										   
	HTTPЗапросВнБД = Новый HTTPЗапрос(ТекстЗапроса);
	HTTPОтветВнБД = HTTPСоеднинениеВнБД.Получить(HTTPЗапросВнБД);
	
	РезультатЗапроса = Неопределено;
	РезультатЗапроса = HTTPОтветВнБД.ПолучитьТелоКакСтроку();
	Сообщить("Код состояния " + HTTPОтветВнБД.КодСостояния);
	Возврат РезультатЗапроса;	
	
	
КонецФункции

Процедура ВыполнитьЗапросВБД(Заголовки, СтрокаПараметров = "")
	
	HTTPСоеднинениеВнБД = Новый HTTPСоединение(АдресСервера, 
										   Порт,
										   Логин,
										   Пароль);
										   
	ЗапросФайлом = ПолучитьИмяВременногоФайла();
	ФайлЗапрос = Новый ТекстовыйДокумент();
	ФайлЗапрос.УстановитьТекст(Заголовки);
	ФайлЗапрос.Записать(ЗапросФайлом, КодировкаТекста.UTF8);
	HTTPЗапросВнБД = Новый HTTPЗапрос();
	HTTPЗапросВнБД.УстановитьИмяФайлаТела(ЗапросФайлом);
	
	HTTPОтветВнБД = HTTPСоеднинениеВнБД.ОтправитьДляОбработки(HTTPЗапросВнБД);
	
	РезультатЗапроса = Неопределено;
	РезультатЗапроса = HTTPОтветВнБД.ПолучитьТелоКакСтроку();
	Сообщить("Код состояния " + HTTPОтветВнБД.КодСостояния);
	Сообщить("Результат " + РезультатЗапроса);	
	
КонецПроцедуры

Функция ВариантыФорматовОтветов()
	
	ФорматыОтветов = Новый Массив;
	ФорматыОтветов.Добавить("TabSeparated");
	ФорматыОтветов.Добавить("TabSeparatedRaw");
ФорматыОтветов.Добавить("TabSeparatedWithNames");
ФорматыОтветов.Добавить("TabSeparatedWithNamesAndTypes");
ФорматыОтветов.Добавить("Template");
ФорматыОтветов.Добавить("CSV");
ФорматыОтветов.Добавить("CSVWithNames");
ФорматыОтветов.Добавить("CustomSeparated");
ФорматыОтветов.Добавить("Values");
ФорматыОтветов.Добавить("Vertical");
ФорматыОтветов.Добавить("VerticalRaw");
ФорматыОтветов.Добавить("JSON");
ФорматыОтветов.Добавить("JSONString");
ФорматыОтветов.Добавить("JSONCompact");
ФорматыОтветов.Добавить("JSONCompactString");
ФорматыОтветов.Добавить("JSONEachRow");
ФорматыОтветов.Добавить("JSONEachRowWithProgress");
ФорматыОтветов.Добавить("JSONStringEachRow");
ФорматыОтветов.Добавить("JSONStringEachRowWithProgress");
ФорматыОтветов.Добавить("JSONCompactEachRow");
ФорматыОтветов.Добавить("JSONCompactEachRowWithNamesAndTypes");
ФорматыОтветов.Добавить("JSONCompactStringEachRow");
ФорматыОтветов.Добавить("JSONCompactStringEachRowWithNamesAndTypes");
ФорматыОтветов.Добавить("TSKV");
ФорматыОтветов.Добавить("Pretty");
ФорматыОтветов.Добавить("PrettyCompact");
ФорматыОтветов.Добавить("PrettyCompactMonoBlock");
ФорматыОтветов.Добавить("PrettyNoEscapes");
ФорматыОтветов.Добавить("PrettySpace");
ФорматыОтветов.Добавить("Protobuf");
ФорматыОтветов.Добавить("ProtobufSingle");
ФорматыОтветов.Добавить("Avro");
ФорматыОтветов.Добавить("Parquet");
ФорматыОтветов.Добавить("Arrow");
ФорматыОтветов.Добавить("ArrowStream");
ФорматыОтветов.Добавить("RowBinary");
ФорматыОтветов.Добавить("RowBinaryWithNamesAndTypes");
ФорматыОтветов.Добавить("Native");
ФорматыОтветов.Добавить("Null");
ФорматыОтветов.Добавить("XML");
ФорматыОтветов.Добавить("RawBLOB");
возврат ФорматыОтветов;	
КонецФункции

#КонецОбласти


#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//К удалению
	ЗаполнитьПараметрыДляТестов();
	//<----
	Элементы.ФорматПринимаемыхДанных.СписокВыбора.ЗагрузитьЗначения(ВариантыФорматовОтветов());
	
	Операции_CH = Новый Массив;
	Операции_CH = ОбработкаОбъект().РеализованныеОперации();
	Элементы.ТекущаяОперация.СписокВыбора.ЗагрузитьЗначения(Операции_CH);
	Элементы.ГруппаНастройкаВыборкиДанных.Видимость = Ложь;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
// Код процедур и функций
#КонецОбласти

//#Область ОбработчикиСобытийЭлементовТаблицыФормы<ИмяТаблицыФормы>
//// Код процедур и функций
//#КонецОбласти

#Область ОбработчикиКомандФормы
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПараметрыПодключения()
	            
	ПараметрыПодключения = Новый Структура;
	ПараметрыПодключения.Вставить("АдресСервера", АдресСервера);
	ПараметрыПодключения.Вставить("Порт", Порт);
	ПараметрыПодключения.Вставить("Логин", Логин);
	//ПараметрыПодключения.Вставить("Пароль", Пароль);	
	
	Возврат ПараметрыПодключения;
КонецФункции

&НаСервере
Функция ОбработкаОбъект()
	
	Возврат РеквизитФормыВЗначение("Объект");
	
КонецФункции

//
//для разработки
//
&НаСервере
Процедура ЗаполнитьПараметрыДляТестов()
	
	ИмяБД = "mch1";
	ОснТаблица = "testTable";
	ТекстЗапросаВыборки = СтрШаблон("Select * FROM %1.%2 FORMAT JSON", ИмяБД, ОснТаблица);	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ПараметрыПодключенияПоУмолчанию());
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокТаблиц(Команда)
	
	ПолучитьСписокБазДанных(ПараметрыПодключения());
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСписокБазДанных(ПараметрыПодключения)
	//ТестовыйЗапрос(ПараметрыПодключенияПоУмолчанию());
	ВыборкаЗапроса = ОбработкаОбъект().ЗапросСписокВсехБД(ПараметрыПодключенияПоУмолчанию());
	
	Если ПустаяСтрока(СокрЛП(ВыборкаЗапроса)) Тогда
		Возврат;
	КонецЕсли;
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(ВыборкаЗапроса);
	Структура = ПрочитатьJSON(Чтение);
	
	Элементы.ИмяБД.СписокВыбора.Очистить();
	
	Для каждого тОтвет из Структура.data Цикл
		Элементы.ИмяБД.СписокВыбора.Добавить(тОтвет.name);
	КонецЦикла;
	
КонецПроцедуры
#КонецОбласти
//CREATE DATABASE [IF NOT EXISTS] db_name [ON CLUSTER cluster] 