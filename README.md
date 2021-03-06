# clickHouse1c
интеграция ClickHouse и 1с. 
демо вызовы 
Взаимодействие реализовано через HTTP вызовы

Быстрый запуск CH на локальной машине
```
docker run -d --name some-clickhouse-server -p 8123:8123 yandex/clickhouse-server
```

# Возможности
 - Просмотр структуры СУБД по базам данных, таблицам 
 - Подготовка запросов на создание баз данных, таблиц, выборка данных из ClickHouse
 - Выполнение запросов
 - Select запросы  по умолчанию обрабатывабтся как формат JSON и загружаются в табличный документ на форме обработки(если предполагается другой формат - ответ отобразиться сообщением)

 # Вариант интеграции "Выгрузка истории выполнения универсальных заданий"
 - Ускоряем отборы 
 - Снижаем количество запросов к продуктовой БД
 - Экономим место в БД
 Дано:
 Есть универсальные задания. Результат работы фиксируется в РегистреСведений "ИсторияВыполненияЗаданий".
 Измерения "ИмяЗадания", Ресурсы "РезультатВыполнения, ОписаниеОшибки, КоличествоОбработанныхЗаписей, ВремяВыполнения"
 Объем регистра порядка 25 Гб за 3 месяца.
Решение: Провести выгрузку в ClickHouse. В основной базе оставить данные за 3 последние дня.

* Создаем таблицу в ClickHouse

```sql
 CREATE TABLE drkBase.logExtJob (
  `EventDate` DateTime,
  `JobName` String,
  `resultJob` Int8,
  `JobDescribe` String,
  `CountRecord` UInt8,
  `TimeJob` UInt16
) ENGINE = MergeTree PRIMARY KEY (JobName, EventDate)
ORDER BY
  (JobName, EventDate) SETTINGS index_granularity = 8192
```

* На стороне 1с выгрузка:
```bsl
///[...]
///Выборка записей, Сбор данных для выгрузки
///			
            ДанныеВЗапрос = Новый Массив;
			Для каждого КиЗ из ИсходнаяСтруктура Цикл
				Если ТипЗнч(КиЗ.Значение) = Тип("Дата") Тогда	
					ДанныеВЗапрос.Добавить("toDateTime('"+Формат(КиЗ.Значение, "ДФ='yyyy-MM-dd ЧЧ:мм:сс'")+"')");
				ИначеЕсли ТипЗнч(КиЗ.Значение) = Тип("Булево") Тогда	
					ДанныеВЗапрос.Добавить( Строка(?(КиЗ.Значение, 1, 0)));
				ИначеЕсли ТипЗнч(КиЗ.Значение) = Тип("Число") Тогда	
					ДанныеВЗапрос.Добавить(Формат(КиЗ.Значение,"ЧРГ=' '; ЧН=0; ЧГ=0"));				
				Иначе	
					ЧастьСтроки = Строка(КиЗ.Значение);
					ЧастьСтроки = СтрЗаменить(ЧастьСтроки, "'", """''""");
					ДанныеВЗапрос.Добавить("'"+ЧастьСтроки+"'");
				КонецЕсли;	
			КонецЦикла;
			
			СтрокиДанных.Добавить(Символы.ПС + "("+СтрСоединить(ДанныеВЗапрос,",")+")");
 ///[...]           
#Область ОтправкаЛогаВClickHouse

АдресСервера = ["]АдресСервера];			
Порт = [Открытый для http порт];			
Логин = ВашЛогин;			
Пароль = ВашПароль;			

ТекстЗапроса = "INSERT INTO  drkBase.logExtJob (EventDate, JobName, resultJob, JobDescribe, CountRecord, TimeJob)			
|VALUES			
|";			
ТекстЗапроса = ТекстЗапроса + СтрСоединить(СтрокиДанных,",");			

HTTPСоединение = Новый HTTPСоединение(АдресСервера, Порт, Логин, Пароль);			
ИмяВремФайла = ПолучитьИмяВременногоФайла();			
ФайлЗапрос = Новый ТекстовыйДокумент();			
ФайлЗапрос.УстановитьТекст(ТекстЗапроса);			
ФайлЗапрос.Записать(ИмяВремФайла, КодировкаТекста.UTF8);			
			
HTTPЗапросВнБД = Новый HTTPЗапрос();			
HTTPЗапросВнБД.УстановитьИмяФайлаТела(ИмяВремФайла);			
			
HTTPОтветВнБД = HTTPСоединение.ОтправитьДляОбработки(HTTPЗапросВнБД);			
#КонецОбласти	

 ```

* Для просмотра истории используем отчет /bin/ИсторияФоновыхЗаданий.erf