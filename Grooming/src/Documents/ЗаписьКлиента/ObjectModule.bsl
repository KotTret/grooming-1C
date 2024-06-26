
#Область ОбработчикиСобытий
Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.ЗаказыКлиентов.Записывать = Истина; 
	
	Для Каждого ТекСтрокаУслуги Из Услуги Цикл
		Движение = Движения.ЗаказыКлиентов.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Номенклатура = ТекСтрокаУслуги.Услуга;
		Движение.Период = Дата;
		Движение.Клиент = Клиент;
		Движение.ЗаписьКлиента = Ссылка;
		Движение.Сумма = ТекСтрокаУслуги.Стоимость;
	КонецЦикла;
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
     Возврат;
КонецЕсли;

	Если Ответственный.Пустая() Тогда 
		Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(Ссылка) И УслугаОказана = Ложь Тогда
		УслугаОказана = Документы.ЗаписьКлиента.ПроверитьОказаниеУслуг(Ссылка);
	КонецЕсли;
	
	ДлительностьУслуг = РассчитатьДатуОкончанияЗаписи();
	Если ДлительностьУслуг = 0 Тогда 
		ДлительностьУслуг = 60;
	КонецЕсли;
	ДатаОкончанияЗаписи = ДатаЗаписи + ДлительностьУслуг*60;
КонецПроцедуры
#КонецОбласти  

#Область СлужебныеПроцедурыИФункции
Функция РассчитатьДатуОкончанияЗаписи()
	ТЧУслуги = Услуги.Выгрузить(,"Услуга");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТЧУслуги", ТЧУслуги);
	Запрос.Текст = "ВЫБРАТЬ
	|	ТЧУслуги.Услуга КАК Номенклатура
	|ПОМЕСТИТЬ ВТ_Номенклатура
	|ИЗ
	|	&ТЧУслуги КАК ТЧУслуги
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(Ном.ДлительностьУслуги) КАК ДлительностьУслуги
	|ИЗ
	|	ВТ_Номенклатура КАК ВТ_Номенклатура
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Ном
	|		ПО ВТ_Номенклатура.Номенклатура = Ном.Ссылка";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.ДлительностьУслуги;
КонецФункции
#КонецОбласти
