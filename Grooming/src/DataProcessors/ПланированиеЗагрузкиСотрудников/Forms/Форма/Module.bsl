
&НаКлиенте
Процедура Вперед(Команда)
	УстановитьПредставлениеПериода("Вперед"); 
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	УстановитьПредставлениеПериода("Назад"); 
КонецПроцедуры

&НаКлиенте
Процедура Сегодня(Команда)
	УстановитьПредставлениеПериода("Сегодня");
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если НЕ ЗначениеЗаполнено(ВариантПериода) Тогда
		ВариантПериода = "День";
	КонецЕсли;

	УстановитьОтображениеПланировщика();  
КонецПроцедуры  

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьПредставлениеПериода();
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеПланировщика()
	
	НачалоРабочегоДня = Константы.НачалоРабочегоДня.Получить();
	ОкончаниеРабочегоДня =  Константы.ОкончаниеРабочегоДня.Получить();
	
	Планировщик.ОтображатьТекущуюДату = Истина;
	Планировщик.ОтступСНачалаПереносаШкалыВремени = НачалоРабочегоДня;
	Планировщик.ОтступСКонцаПереносаШкалыВремени = ?(ОкончаниеРабочегоДня = 0, 0, 24 - ОкончаниеРабочегоДня);
	Планировщик.ЕдиницаПериодическогоВарианта   = ТипЕдиницыШкалыВремени.Час;
	Планировщик.КратностьПериодическогоВарианта = 24;
	Планировщик.ВыравниватьГраницыЭлементовПоШкалеВремени = Ложь;
	Планировщик.ФорматПеренесенныхЗаголовковШкалыВремени = "ДФ='дддд, д ММММ гггг'";
	
КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьПланировщикНаСервере()
	
	Запрос = Новый Запрос;   
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаписьКлиента.Сотрудник КАК Сотрудник,
	|	ЗаписьКлиента.Сотрудник.Представление КАК СотрудникПредставление,
	|	ЗаписьКлиента.ДатаЗаписи КАК ДатаЗаписи,
	|	ЗаписьКлиента.ДатаОкончанияЗаписи КАК ДатаОкончанияЗаписи,
	|	ЗаписьКлиента.Клиент.Представление КАК КлиентПредставление,
	|	ЗаписьКлиента.Ссылка КАК ЗаписьКлиента,
	|	ЗаписьКлиента.УслугаОказана КАК УслугаОказана
	|ПОМЕСТИТЬ ВТ_Записи
	|ИЗ
	|	Документ.ЗаписьКлиента КАК ЗаписьКлиента
	|ГДЕ
	|	ЗаписьКлиента.Проведен
	|	И ЗаписьКлиента.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РеализацияТоваровИУслуг.Основание КАК Основание,
	|	РеализацияТоваровИУслуг.ПризнакОплаты КАК ПризнакОплаты
	|ПОМЕСТИТЬ ВТ_Услуги
	|ИЗ
	|	Документ.РеализацияТоваровИУслуг КАК РеализацияТоваровИУслуг
	|ГДЕ
	|	РеализацияТоваровИУслуг.Основание В
	|			(ВЫБРАТЬ
	|				ВТ_Записи.ЗаписьКлиента
	|			ИЗ
	|				ВТ_Записи)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Записи.Сотрудник КАК Сотрудник,
	|	ВТ_Записи.СотрудникПредставление КАК СотрудникПредставление,
	|	ВТ_Записи.ДатаЗаписи КАК ДатаЗаписи,
	|	ВТ_Записи.ДатаОкончанияЗаписи КАК ДатаОкончанияЗаписи,
	|	ВТ_Записи.КлиентПредставление КАК КлиентПредставление,
	|	ВТ_Записи.ЗаписьКлиента КАК ЗаписьКлиента,
	|	ВТ_Записи.УслугаОказана КАК УслугаОказана,
	|	ЕСТЬNULL(ВТ_Услуги.ПризнакОплаты, ЗНАЧЕНИЕ(Перечисление.ОплатаДокумента.НеОплачен)) КАК ПризнакОплаты
	|ИЗ
	|	ВТ_Записи КАК ВТ_Записи
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Услуги КАК ВТ_Услуги
	|		ПО ВТ_Записи.ЗаписьКлиента = ВТ_Услуги.Основание
	|ИТОГИ ПО
	|	Сотрудник";
	
	ТекущийПериод = Планировщик.ТекущиеПериодыОтображения[0];
	Запрос.УстановитьПараметр("ДатаНачала", ТекущийПериод.Начало);
	Запрос.УстановитьПараметр("ДатаОкончания", ТекущийПериод.Конец);

	Планировщик.Элементы.Очистить();
	ИзмеренияПланировщика = Планировщик.Измерения;
	ИзмеренияПланировщика.Очистить();
	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаСотрудник = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ИзмерениеСотрудники = ИзмеренияПланировщика.Добавить("Сотрудники");
	Пока ВыборкаСотрудник.Следующий() Цикл
		НовоеИзмерение = ИзмерениеСотрудники.Элементы.Добавить(ВыборкаСотрудник.Сотрудник);
		НовоеИзмерение.Текст = ВыборкаСотрудник.СотрудникПредставление;
		
		Выборка = ВыборкаСотрудник.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			ДатаНачала = Выборка.ДатаЗаписи;
			ДатаОкончания = Выборка.ДатаОкончанияЗаписи;
			
			СоответствиеЗначений = Новый Соответствие;
			СоответствиеЗначений.Вставить("Сотрудники", Выборка.Сотрудник);
			
			НовыйЭлемент = Планировщик.Элементы.Добавить(ДатаНачала, ДатаОкончания);
			НовыйЭлемент.Текст = СокрЛП(Выборка.КлиентПредставление);
			НовыйЭлемент.Значение = Выборка.ЗаписьКлиента;
			Если Выборка.УслугаОказана Тогда
				НовыйЭлемент.ЦветФона = Новый Цвет(255, 153, 0);
			Иначе
				НовыйЭлемент.ЦветФона = Новый Цвет(255, 237, 175);
			КонецЕсли; 
			
			Если Выборка.ПризнакОплаты = Перечисления.ОплатаДокумента.ПолностьюОплачен Тогда 
				НовыйЭлемент.ЦветРамки = WebЦвета.Зеленый;
			Иначе 
				НовыйЭлемент.ЦветРамки = WebЦвета.Красный;
			КонецЕсли;
	
			НовыйЭлемент.ЗначенияИзмерений = Новый ФиксированноеСоответствие(СоответствиеЗначений);
			
		КонецЦикла;
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредставлениеПериода(Вариант = Неопределено)
	ТекущийПериод = Планировщик.ТекущиеПериодыОтображения[0];
	
	Если НЕ ЗначениеЗаполнено(ТекущийПериод.Начало) Тогда
		ТекущийПериод.Начало = ТекущаяДата();
	КонецЕсли;	                             
	
	Планировщик.ТекущиеПериодыОтображения.Очистить();
	
	Если ВариантПериода = "День" Тогда
		
		Если Вариант = Неопределено Тогда
			ДатаНачала = НачалоДня(ТекущийПериод.Начало);
		ИначеЕсли Вариант = "Назад" Тогда
			ДатаНачала = НачалоДня(ТекущийПериод.Начало) - 60 * 60 * 24;
		ИначеЕсли Вариант = "Вперед" Тогда
			ДатаНачала = НачалоДня(ТекущийПериод.Начало) + 60 * 60 * 24;
		ИначеЕсли Вариант = "Сегодня" Тогда
			ДатаНачала = НачалоДня(ТекущаяДата());
		КонецЕсли;
		
		ДатаОкончания  = КонецДня(ДатаНачала);
		Планировщик.ТекущиеПериодыОтображения.Добавить(ДатаНачала, ДатаОкончания); 
		
		ПредставлениеПериода = Формат(ДатаНачала, "ДФ='дд ММММ'");
		
	ИначеЕсли ВариантПериода = "Неделя" Тогда
		
		Если Вариант = Неопределено Тогда
			ДатаНачала = НачалоНедели(ТекущийПериод.Начало);
		ИначеЕсли Вариант = "Назад" Тогда
			ДатаНачала = НачалоНедели(ТекущийПериод.Начало) - 7 * 60 * 60 * 24;
		ИначеЕсли Вариант = "Вперед" Тогда
			ДатаНачала = НачалоНедели(ТекущийПериод.Начало) + 7 * 60 * 60 * 24;
		ИначеЕсли Вариант = "Сегодня" Тогда
			ДатаНачала = НачалоНедели(ТекущаяДата());
		КонецЕсли;
		
		ДатаОкончания  = КонецНедели(ДатаНачала);
		Планировщик.ТекущиеПериодыОтображения.Добавить(ДатаНачала, ДатаОкончания);
		
		ПредставлениеПериода = СтрШаблон("%1 - %2", Формат(ДатаНачала, "ДФ='дд ММММ'"), Формат(ДатаОкончания, "ДФ='дд ММММ гггг'"));
		
	ИначеЕсли ВариантПериода = "Месяц" Тогда
		
		Если Вариант = Неопределено Тогда
			ДатаНачала = НачалоМесяца(ТекущийПериод.Начало);
		ИначеЕсли Вариант = "Назад" Тогда
			ДатаНачала = ДобавитьМесяц(ТекущийПериод.Начало, -1);
		ИначеЕсли Вариант = "Вперед" Тогда
			ДатаНачала = ДобавитьМесяц(ТекущийПериод.Начало, 1);
		ИначеЕсли Вариант = "Сегодня" Тогда
			ДатаНачала = НачалоМесяца(ТекущаяДата());
		КонецЕсли;
		
		ДатаОкончания  = КонецМесяца(ДатаНачала);
		Планировщик.ТекущиеПериодыОтображения.Добавить(ДатаНачала, ДатаОкончания);
		
		ПредставлениеПериода = ПредставлениеПериода(ДатаНачала, ДатаОкончания);
		
	КонецЕсли;
	
	ЗаполнитьПланировщикНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВариантПериодаПриИзменении(Элемент)
	 УстановитьПредставлениеПериода();
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПриСменеТекущегоПериодаОтображения(Элемент, ТекущиеПериодыОтображения, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПередНачаломБыстрогоРедактирования(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	ПараметрыОткрытияФормы = Новый Структура("Ключ", Элемент.ВыделенныеЭлементы[0].Значение);
	ОткрытьФорму("Документ.ЗаписьКлиента.Форма.ФормаДокумента", ПараметрыОткрытияФормы,,ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПередСозданием(Элемент, Начало, Конец, ЗначенияИзмерений, Текст, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытияФормы = Новый Структура("Начало, Окончание, Сотрудник", Начало, Конец,
		ЗначенияИзмерений.Получить("Сотрудники")); 
		
		ОткрытьФорму("Документ.ЗаписьКлиента.Форма.ФормаДокумента", ПараметрыОткрытияФормы,,ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Записан заказ" Тогда
		Планировщик.Элементы.Очистить();
		ЗаполнитьПланировщикНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ЗаполнитьПланировщикНаСервере();
КонецПроцедуры



























