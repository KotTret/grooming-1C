#Область ОбработчикиСобытийФормы
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Объект.Ответственный.Пустая() Тогда
		Объект.Ответственный  = УзнатьТекущегоПользователяКлиентПовтИсп.УзнатьТекущегоПользователя();
	КонецЕсли;

КонецПроцедуры
#КонецОбласти
#Область ОбработчикиСобытийЭлементовТаблицыФормыНоменклатура
&НаКлиенте
Процедура НоменклатураЦенаПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Номенклатура.ТекущиеДанные;
	РаботаСТабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураСуммаПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Номенклатура.ТекущиеДанные;
	РаботаСТабличнымиЧастямиКлиент.ПересчитатьЦенуВСтрокеТабличнойЧасти(СтрокаТЧ);
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураКоличествоПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Номенклатура.ТекущиеДанные;
	РаботаСТабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
КонецПроцедуры
&НаКлиенте
Процедура НоменклатураТоварПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Номенклатура.ТекущиеДанные;
	Если ЗначениеЗаполнено(СтрокаТЧ.Номенклатура) Тогда
		СрокГодностиНоменклатуры = УзнатьСрокГодностиНоменклатуры(СтрокаТЧ.Номенклатура);
		СТрокаТЧ.СрокГодности = Объект.Дата + СрокГодностиНоменклатуры * 24 * 60 * 60;
	КонецЕсли;

КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервереБезКонтекста
Функция УзнатьСрокГодностиНоменклатуры(Номенклатура)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Номенклатура.СрокГодности КАК СрокГодности
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", Номенклатура);

	РезультатЗапроса = Запрос.Выполнить();

	Если РезультатЗапроса.Пустой() Тогда
		Возврат 0;
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.СрокГодности;
	КонецЕсли;

КонецФункции
#КонецОбласти